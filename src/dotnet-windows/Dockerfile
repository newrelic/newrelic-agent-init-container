# To build one auto-instrumentation image for dotnet, please:
#  - Download the newrelic dotnet artifacts to `/instrumentation` directory. This is required as when instrumenting the pod,
#    one init container will be created to copy the files to your app's container.
#  - Following environment variables are injected to the application container to enable the auto-instrumentation.
#    https://docs.newrelic.com/docs/apm/agents/net-agent/configuration/net-agent-configuration/#net-framework-env-variables
#    https://docs.newrelic.com/docs/apm/agents/net-agent/configuration/net-agent-configuration/#net-core-env-variables

# This container needs to match the target architecture.
# Valid TARGETARCH: 2022, 2025
ARG TARGETARCH=2025

# Pin both possible base images by hash; the final FROM selects between them at build time.
FROM mcr.microsoft.com/windows/nanoserver:ltsc2022@sha256:7644d94e806b07c22d7e276a8cdbcbffac1d02bf3d5170884302d0e9b0a519e9 AS base-2022
FROM mcr.microsoft.com/windows/nanoserver:ltsc2025@sha256:c71ca7f010608e202e62df477ca19542dd9c44e2a20508af8f92ff63859b0540 AS base-2025

# This container can be pinned to latest OS since all it does is get the data which is OS agnostic.
FROM mcr.microsoft.com/windows/nanoserver:ltsc2025@sha256:c71ca7f010608e202e62df477ca19542dd9c44e2a20508af8f92ff63859b0540 AS build

# Set the working directory
WORKDIR C:\\instrumentation

# Copy batch script to image to root of C:
COPY dotnet-agent-download.cmd /

# Argument to specify the version of the New Relic agent
ARG AGENT_VERSION="latest"

# Download and extract the New Relic .NET agent using command prompt's curl.exe
RUN C:\\dotnet-agent-download.cmd %AGENT_VERSION% || exit 1

COPY agentinfo.json .
COPY agentinfo.json .\\netcore\\agentinfo.json
COPY agentinfo.json .\\netframework\\agentinfo.json

# Select the pre-pinned base image for the target architecture.
FROM base-${TARGETARCH}

COPY --from=build /instrumentation /instrumentation