# To build one auto-instrumentation image for Node.js, please:
# - Ensure the packages are installed in the `/instrumentation` directory. This is required as when instrumenting the pod,
#   one init container will be created to copy all the content in `/instrumentation` directory to your app's container. Then
#   update the `NODE_OPTIONS` environment variable accordingly.
#   In the first stage, install all the required packages in one custom directory.
#   Then in the second stage, copy the directory to `/instrumentation`.
# - Ensure you have `newrelic`, and`@newrelic/native-metrics`.
# - Grant the necessary access to `/instrumentation` directory. `chmod -R go+r /instrumentation`
ARG RUNTIME_VERSION=20

FROM node:${RUNTIME_VERSION} AS build

WORKDIR /instrumentation

# Install dependencies
ARG AGENT_VERSION=latest
RUN npm install newrelic@${AGENT_VERSION}

# copy instrumentation file
COPY newrelicinstrumentation.js .

# initcontainer
FROM busybox:latest@sha256:9ae97d36d26566ff84e8893c64a6dc4fe8ca6d1144bf5b87b2b85a32def253c7
COPY --from=build /instrumentation /instrumentation
RUN chmod -R go+r /instrumentation
