# To build one auto-instrumentation image for Ruby, please:
# - Ensure the packages are installed in the `/instrumentation` directory. This is required as when instrumenting the pod,
#   one init container will be created to copy all the content in `/instrumentation` directory to your app's container.
# - Grant the necessary access to `/instrumentation` directory. `chmod -R go+r /instrumentation`

FROM ruby:latest@sha256:3ae98cd2cc44319a92cc7f51fa95dc9dcb2bbb9a15a57b126c21ff43f5f86d11 AS build
WORKDIR /operator-build

ARG AGENT_VERSION

# Install gems from Gemfile into the `workspace` directory
ADD Gemfile .
RUN BUNDLE_PATH=workspace bundle install

FROM busybox:latest@sha256:c230832bd3b0be59a6c47ed64294f9ce71e91b327957920b6929a0caa8353140

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
