# To build one auto-instrumentation image for PHP, please:
#  - Download the newrelic php artefacts to `/instrumentation` directory. This is required as when instrumenting the pod,
#    one init container will be created to copy the files to your app's container.
#  - Grant the necessary access to the files in the `/instrumentation` directory.
FROM alpine:latest@sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0 as build
RUN apk update && apk add ca-certificates
ARG version
ARG architecture
ARG php
WORKDIR /instrumentation
RUN wget -c "https://download.newrelic.com/php_agent/release/newrelic-${php}-${version}-${architecture}.tar.gz" -O - | tar -xz --strip-components 1

FROM busybox:latest@sha256:9ae97d36d26566ff84e8893c64a6dc4fe8ca6d1144bf5b87b2b85a32def253c7
COPY --from=build /instrumentation /instrumentation
RUN chmod -R go+r /instrumentation
