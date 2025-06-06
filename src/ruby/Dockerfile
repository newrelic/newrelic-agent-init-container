# To build one auto-instrumentation image for Ruby, please:
# - Ensure the packages are installed in the `/instrumentation` directory. This is required as when instrumenting the pod,
#   one init container will be created to copy all the content in `/instrumentation` directory to your app's container.
# - Grant the necessary access to `/instrumentation` directory. `chmod -R go+r /instrumentation`

FROM ruby:latest@sha256:d31b448100c85100876c4a5290375cca26e231d915d7a037599e33e02238560c AS build
WORKDIR /operator-build

ARG AGENT_VERSION

# Install gems from Gemfile into the `workspace` directory
ADD Gemfile .
RUN BUNDLE_PATH=workspace bundle install

FROM busybox:stable@sha256:7edf5efe6b86dbf01ccc3c76b32a37a8e23b84e6bad81ce8ae8c221fa456fda8

# Copy build artifacts from previous
COPY --from=build /operator-build /operator-build
WORKDIR /operator-build

# Shell command to search inside the `workspace/ruby` directory for a directory that starts with `newrelic_rpm`.
# Example of a found result: workspace/ruby/3.2.0/gems/newrelic_rpm-9.9.0
# Copy the result into a new directory called `/instrumentation`.
RUN sh -c "find 'workspace/ruby/' -type d -name newrelic_rpm\\* -exec cp -r '{}' /instrumentation \\;"

# Adjust permissions of `instrumentation` directory to readable by everyone
RUN chmod -R go+r /instrumentation

# Clean up build artifacts
RUN rm -rf /operator-build
