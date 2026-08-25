# To build one auto-instrumentation image for PHP, please:
#  - Download the newrelic php artefacts to `/instrumentation` directory. This is required as when instrumenting the pod,
#    one init container will be created to copy the files to your app's container.
#  - Grant the necessary access to the files in the `/instrumentation` directory.
FROM alpine:latest@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS build
RUN apk update && apk add ca-certificates && apk add --no-cache bash
ARG AGENT_VERSION
ARG LIBC
WORKDIR /instrumentation
COPY php-agent-download.sh k8s-php-install.sh nr_env_to_ini.sh nrini.mapping ./
RUN chmod +x php-agent-download.sh k8s-php-install.sh nr_env_to_ini.sh
RUN ./php-agent-download.sh $LIBC $AGENT_VERSION
RUN rm php-agent-download.sh
RUN mkdir php-agent php-agent/bin php-agent/ext php-agent/ini php-agent/logs
COPY newrelic.ini ./php-agent/ini/

FROM busybox:stable@sha256:73aaf090f3d85aa34ee199857f03fa3a95c8ede2ffd4cc2cdb5b94e566b11662
COPY --from=build /instrumentation /instrumentation
RUN chmod -R go+r /instrumentation
