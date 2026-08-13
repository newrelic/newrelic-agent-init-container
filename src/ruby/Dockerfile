# To build one auto-instrumentation image for Ruby, please:
# - Ensure the packages are installed in the `/instrumentation` directory. This is required as when instrumenting the pod,
#   one init container will be created to copy all the content in `/instrumentation` directory to your app's container.
# - Grant the necessary access to `/instrumentation` directory. `chmod -R go+r /instrumentation`

FROM ruby:latest@sha256:d9a5d26be31a40fb043069f816ba39139c1f38758aea530341eb7e2c153e4ab4 AS build
WORKDIR /operator-build

ARG AGENT_VERSION

# Install gems from Gemfile into the `workspace` directory
ADD Gemfile .
RUN BUNDLE_PATH=workspace bundle install

FROM busybox:stable@sha256:73aaf090f3d85aa34ee199857f03fa3a95c8ede2ffd4cc2cdb5b94e566b11662

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
