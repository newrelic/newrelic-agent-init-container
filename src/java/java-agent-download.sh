#!/bin/sh
:'Shell script to download the New Relic Java agent.
  This script takes an optional agent `version` argument (e.g. java-agent-download.sh 8.12.0).
  If no input argument is provided, then the current Java agent version will be downloaded,
  otherwise the agent version specified by the input argument will be downloaded.'

AGENT_VERSION=$1

# If the input arg is empty...
if [[ -z "$AGENT_VERSION" ]]; then
    # Download current Java agent version if no argument is provided
    wget https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-agent.jar -O /newrelic-agent.jar
else
    # Download the Java agent version specified by the provided input argument
    wget https://download.newrelic.com/newrelic/java-agent/newrelic-agent/$1/newrelic-agent-$1.jar -O /newrelic-agent.jar
fi
