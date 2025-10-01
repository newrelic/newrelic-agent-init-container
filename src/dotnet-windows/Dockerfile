# To build one auto-instrumentation image for dotnet, please:
#  - Download the newrelic dotnet artifacts to `/instrumentation` directory. This is required as when instrumenting the pod,
#    one init container will be created to copy the files to your app's container.
#  - Following environment variables are injected to the application container to enable the auto-instrumentation.
#    https://docs.newrelic.com/docs/apm/agents/net-agent/configuration/net-agent-configuration/#net-framework-env-variables
#    https://docs.newrelic.com/docs/apm/agents/net-agent/configuration/net-agent-configuration/#net-core-env-variables

# This container needs to match the target architecture.
# Valid TARGETARCH: ltsc2022, ltsc2025
ARG TARGETARCH

# This container can be pinned to latest OS since all it does is get the data which is OS agnostic.
FROM mcr.microsoft.com/windows/nanoserver:ltsc2025@sha256:252ba371c2f50ae797d81ae9d87405b55119714817fead9f406218b556e3ddeb as build

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

# This container needs to match the target architecture.
FROM mcr.microsoft.com/windows/nanoserver:ltsc${TARGETARCH}

COPY --from=build /instrumentation /instrumentation