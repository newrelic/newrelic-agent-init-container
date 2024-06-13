# To build one auto-instrumentation image for Node.js, please:
# - Ensure the packages are installed in the `/instrumentation` directory. This is required as when instrumenting the pod,
#   one init container will be created to copy all the content in `/instrumentation` directory to your app's container. Then
#   update the `NODE_OPTIONS` environment variable accordingly.
#   In the first stage, install all the required packages in one custom directory.
#   Then in the second stage, copy the directory to `/instrumentation`.
# - Ensure you have `newrelic`, and`@newrelic/native-metrics`.
# - Grant the necessary access to `/instrumentation` directory. `chmod -R go+r /instrumentation`
FROM node:20 AS build_node20

WORKDIR /instrumentation

# Install dependencies
ARG AGENT_VERSION=latest
RUN npm install newrelic@${AGENT_VERSION}

# copy instrumentation file
COPY newrelicinstrumentation_nodeversion.js newrelicinstrumentation.js

FROM node:18 AS build_node18

WORKDIR /instrumentation

# Install dependencies
ARG AGENT_VERSION=latest
RUN npm install newrelic@${AGENT_VERSION}

# copy instrumentation file
COPY newrelicinstrumentation_nodeversion.js newrelicinstrumentation.js

FROM node:16 AS build_node16

WORKDIR /instrumentation

# Install dependencies
ARG AGENT_VERSION=latest
RUN npm install newrelic@${AGENT_VERSION}

# copy instrumentation file
COPY newrelicinstrumentation_nodeversion.js newrelicinstrumentation.js

# initcontainer
FROM busybox
COPY --from=build_node20 /instrumentation /instrumentation/node20x
COPY --from=build_node18 /instrumentation /instrumentation/node18x
COPY --from=build_node16 /instrumentation /instrumentation/node16x
COPY newrelicinstrumentation_root.js /instrumentation/newrelicinstrumentation.js
RUN chmod -R go+r /instrumentation
