# To build one auto-instrumentation image for PHP, please:
#  - Download the newrelic php artefacts to `/instrumentation` directory. This is required as when instrumenting the pod,
#    one init container will be created to copy the files to your app's container.
#  - Grant the necessary access to the files in the `/instrumentation` directory.
FROM alpine:latest@sha256:77726ef6b57ddf65bb551896826ec38bc3e53f75cdde31354fbffb4f25238ebd AS build
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

FROM busybox:latest@sha256:9ae97d36d26566ff84e8893c64a6dc4fe8ca6d1144bf5b87b2b85a32def253c7
COPY --from=build /instrumentation /instrumentation
RUN chmod -R go+r /instrumentation
