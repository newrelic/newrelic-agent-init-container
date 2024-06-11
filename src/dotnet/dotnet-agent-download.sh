#!/bin/sh

TARGETARCH=$1
AGENT_VERSION=$2

if [[ "${TARGETARCH}" == "arm" || "${TARGETARCH}" == "aarch" || "${TARGETARCH}" == "aarch64" ]]; then
    TARGETARCH=arm64
fi

# If the input arg is empty...
if [[ -z "$AGENT_VERSION" ]]; then
    # Download current .NET agent version if no argument is provided
    wget -c "https://download.newrelic.com/dot_net_agent/latest_release/newrelic-dotnet-agent_${TARGETARCH}.tar.gz" -O - | tar -xz --strip-components 1
else
    # Download the .NET agent version specified by the provided input argument
    wget -c "https://download.newrelic.com/dot_net_agent/previous_releases/${AGENT_VERSION}/newrelic-dotnet-agent_${AGENT_VERSION}_${TARGETARCH}.tar.gz" -O - | tar -xz --strip-components 1
fi
