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
FROM mcr.microsoft.com/windows/nanoserver:ltsc2025@sha256:f49449a998f8ba4b1bd5b00c2fbd0b7a34bf9471078f5d79b80db34be5833398 as build

# Set the working directory
WORKDIR C:\\instrumentation

# Argument to specify the version of the New Relic agent
ARG AGENT_VERSION

# Download and extract the New Relic .NET agent using command prompt's curl.exe
RUN curl.exe -L -o newrelic-agent.zip https://download.newrelic.com/dot_net_agent/latest_release/NewRelicDotNetAgent_%AGENT_VERSION%_x64.zip \
    && tar.exe -xzf newrelic-agent.zip \
    && del newrelic-agent.zip

COPY agentinfo.json .
COPY agentinfo.json .\\netcore\\agentinfo.json
COPY agentinfo.json .\\netframework\\agentinfo.json

# This container needs to match the target architecture.
FROM mcr.microsoft.com/windows/nanoserver:ltsc${TARGETARCH}

COPY --from=build /instrumentation /instrumentation