# To build one auto-instrumentation image for dotnet, please:
#  - Download the newrelic dotnet artifacts to `/instrumentation` directory. This is required as when instrumenting the pod,
#    one init container will be created to copy the files to your app's container.
#  - Grant the necessary access to the files in the `/instrumentation` directory.
#  - Following environment variables are injected to the application container to enable the auto-instrumentation.
#    CORECLR_ENABLE_PROFILING=1
#    CORECLR_PROFILER={36032161-FFC0-4B61-B559-F6C5D41BAE5A}
#    CORECLR_PROFILER_PATH=%InstallationLocation%/libNewRelicProfiler.so
#    CORECLR_NEWRELIC_HOME=%InstallationLocation% 

FROM alpine:3.19.1@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b as build
RUN apk update && apk add ca-certificates
ARG version
ARG architecture
WORKDIR /instrumentation
RUN wget -c "https://download.newrelic.com/dot_net_agent/previous_releases/${version}/newrelic-dotnet-agent_${version}_${architecture}.tar.gz" -O - | tar -xz --strip-components 1

FROM busybox:1.36.1@sha256:50aa4698fa6262977cff89181b2664b99d8a56dbca847bf62f2ef04854597cf8
COPY --from=build /instrumentation /instrumentation
RUN chmod -R go+r /instrumentation
