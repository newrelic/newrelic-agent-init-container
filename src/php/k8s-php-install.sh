#!/bin/sh

ZEND_API_NO=$1 # zend representation of the PHP version number
AGENT_FILEPATH=/newrelic-instrumentation/agent
DAEMON_FILEPATH=/newrelic-instrumentation/daemon
INSTALL_LOG=/newrelic-instrumentation/newrelic-install.log

log() {
  msg="$1"
  timestamp=$(date +"%m-%d-%Y %T")
  echo "${timestamp} : ${msg}" >>${INSTALL_LOG}
}

if [ -z ${ZEND_API_NO} ]; then
  log "Missing Zend api number. Exiting."
  exit 1
fi

log "Installing New Relic PHP Agent for the K8S Agent Operator"

#
# Determine the architecture we are executing on.
#
arch=$( (uname -m) 2>/dev/null) || arch="unknown"
case "${arch}" in
  aarch64 | arm64) arch=aarch64 ;;
  *64* | *amd*) arch=x64 ;;
  *) arch=invalid ;;
esac

# exit if arch is unsupported
if [ "${arch}" != "x64" ] && [ "${arch}" != "aarch64" ]; then
  msg=$(
    cat <<EOF

An unsupported architecture detected.
Please visit:
  https://docs.newrelic.com/docs/apm/agents/php-agent/getting-started/php-agent-compatibility-requirements/
to view compatibilty requirements for the the New Relic PHP agent.
EOF
  )

  log "${msg}"

  log "The install will now exit."
  exit 1
fi

# exit if invalid php x arch
if [ "${arch}" = "aarch64" ]; then
  if [ ${ZEND_API_NO} = "20170218" ] || [ ${ZEND_API_NO} = "20180731" ] || [ ${ZEND_API_NO} = "20190902" ]; then
    log "Invalid arch x php detected. ARM64 is only supported for PHP 8.0+. The install will now exit."
    exit 1
  fi
fi

AGENT_SO=${AGENT_FILEPATH}/${arch}/newrelic-${ZEND_API_NO}.so

# verify existence of agent .so
if [ ! -f ${AGENT_SO} ]; then
  log "Agent binary not found. Exiting."
  exit 1
fi

# copy the .so to the expected location
cp ${AGENT_SO} /newrelic-instrumentation/php-agent/ext/newrelic.so

DAEMON_BINARY=${DAEMON_FILEPATH}/newrelic-daemon.${arch}

# verify existence of the daemon binary
if [ ! -f ${DAEMON_BINARY} ]; then
  log "Daemon binary not found. Exiting."
  exit 1
fi

# copy the binary to the expected location
cp ${DAEMON_BINARY} /newrelic-instrumentation/php-agent/bin/newrelic-daemon

log "Installation complete."
