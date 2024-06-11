# To build one auto-instrumentation image for PHP, please:
#  - Download the newrelic php artefacts to `/instrumentation` directory. This is required as when instrumenting the pod,
#    one init container will be created to copy the files to your app's container.
#  - Grant the necessary access to the files in the `/instrumentation` directory.
FROM alpine:latest as build
RUN apk update && apk add ca-certificates
ARG AGENT_VERSION
ARG LIBC
WORKDIR /instrumentation
COPY php-agent-download.sh .
RUN chmod +x php-agent-download.sh
RUN ./php-agent-download.sh $LIBC $AGENT_VERSION
RUN rm php-agent-download.sh

FROM busybox
COPY --from=build /instrumentation /instrumentation
RUN chmod -R go+r /instrumentation
