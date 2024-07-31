#!/bin/sh

map_file=/newrelic-instrumentation/nrini.mapping
output_file=/newrelic-instrumentation/php-agent/ini/newrelic.ini

if [ ! -z "${NEW_RELIC_LICENSE_KEY}" ]; then
  echo "newrelic.license=${NEW_RELIC_LICENSE_KEY}" >>$output_file
fi

while IFS=':' read -r envvar inivar; do
  if [ -n "$(printenv $envvar)" ]; then
    echo "$inivar=$(printenv $envvar)" >>$output_file
  fi
done <"$map_file"
