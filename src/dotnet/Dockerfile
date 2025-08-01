# To build one auto-instrumentation image for dotnet, please:
#  - Download the newrelic dotnet artifacts to `/instrumentation` directory. This is required as when instrumenting the pod,
#    one init container will be created to copy the files to your app's container.
#  - Grant the necessary access to the files in the `/instrumentation` directory.
#  - Following environment variables are injected to the application container to enable the auto-instrumentation.
#    CORECLR_ENABLE_PROFILING=1
#    CORECLR_PROFILER={36032161-FFC0-4B61-B559-F6C5D41BAE5A}
#    CORECLR_PROFILER_PATH=%InstallationLocation%/libNewRelicProfiler.so
#    CORECLR_NEWRELIC_HOME=%InstallationLocation% 

FROM alpine:latest@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 as build
RUN apk update && apk add ca-certificates
WORKDIR /instrumentation

# Copy shell script to image
COPY dotnet-agent-download.sh /
# Set executable permissions on shell script
RUN chmod +x /dotnet-agent-download.sh
# Execute shell script to download agent, passing the architecture and version build args to it
ARG TARGETARCH
ARG AGENT_VERSION
RUN /dotnet-agent-download.sh $TARGETARCH $AGENT_VERSION

# replace agentinfo.json from the tarball with one that identifies this as a k8s-operator install type
COPY agentinfo.json .

FROM busybox:stable@sha256:31f3955f475e40c62c6d4209f09fd9738cf6cadfc0f4aa76ba2d4d86f061c5b5
COPY --from=build /instrumentation /instrumentation
RUN chmod -R go+r /instrumentation
