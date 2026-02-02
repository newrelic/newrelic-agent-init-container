# To build one auto-instrumentation image for dotnet, please:
#  - Download the newrelic dotnet artifacts to `/instrumentation` directory. This is required as when instrumenting the pod,
#    one init container will be created to copy the files to your app's container.
#  - Grant the necessary access to the files in the `/instrumentation` directory.
#  - Following environment variables are injected to the application container to enable the auto-instrumentation.
#    CORECLR_ENABLE_PROFILING=1
#    CORECLR_PROFILER={36032161-FFC0-4B61-B559-F6C5D41BAE5A}
#    CORECLR_PROFILER_PATH=%InstallationLocation%/libNewRelicProfiler.so
#    CORECLR_NEWRELIC_HOME=%InstallationLocation% 

FROM alpine:latest@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 as build
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

FROM busybox:stable@sha256:851281100cc5f93d8a8f8e1a8976a57ec40a9bc9edd66ad3a621e4aa63326915
COPY --from=build /instrumentation /instrumentation
RUN chmod -R go+r /instrumentation
