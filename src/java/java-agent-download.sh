#!/bin/sh
:'Shell script to download the New Relic Java agent.
  This script takes an optional agent `version` argument (e.g. java-agent-download.sh 8.12.0).
  If no input argument is provided, then the current Java agent version will be downloaded,
  otherwise the agent version specified by the input argument will be downloaded.'

# If the input arg is empty...
if [ -z "$1" ]
then
    # Download current Java agent version if no argument is provided
    wget https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-agent.jar
else
    # Download the Java agent version specified by the provided input argument
    wget https://download.newrelic.com/newrelic/java-agent/newrelic-agent/$1/newrelic-agent-$1.jar
fi

# If the Java agent jar file exists...
if [ -e newrelic*.jar ]
then
    # Rename the Java agent jar file to newrelic-agent.jar
    mv newrelic*.jar newrelic-agent.jar
fi
