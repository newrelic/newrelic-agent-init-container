# To build one auto-instrumentation image for PHP, please:
#  - Download the newrelic php artefacts to `/instrumentation` directory. This is required as when instrumenting the pod,
#    one init container will be created to copy the files to your app's container.
#  - Grant the necessary access to the files in the `/instrumentation` directory.
FROM alpine:latest@sha256:77726ef6b57ddf65bb551896826ec38bc3e53f75cdde31354fbffb4f25238ebd as build
RUN apk update && apk add ca-certificates
ARG version
ARG architecture
ARG php
WORKDIR /instrumentation
RUN wget -c "https://download.newrelic.com/php_agent/release/newrelic-${php}-${version}-${architecture}.tar.gz" -O - | tar -xz --strip-components 1

FROM busybox:latest@sha256:82742949a3709938cbeb9cec79f5eaf3e48b255389f2dcedf2de29ef96fd841c
COPY --from=build /instrumentation /instrumentation
RUN chmod -R go+r /instrumentation
