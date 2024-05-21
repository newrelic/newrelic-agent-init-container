# To build one auto-instrumentation image for Ruby, please:
# - Ensure the packages are installed in the `/instrumentation` directory. This is required as when instrumenting the pod,
#   one init container will be created to copy all the content in `/instrumentation` directory to your app's container.
# - Grant the necessary access to `/instrumentation` directory. `chmod -R go+r /instrumentation`

FROM ruby:latest AS build
WORKDIR /operator-build
ADD Gemfile .
RUN BUNDLE_PATH=workspace bundle install

FROM busybox
COPY --from=build /operator-build /operator-build
WORKDIR /operator-build
# Shell command to search inside the `workspace/ruby` directory for a directory that starts with `newrelic_rpm`.
# Example of a found result: workspace/ruby/3.2.0/gems/newrelic_rpm-9.9.0
# Copy the result into a new directory called `/instrumentation`.
RUN sh -c "find 'workspace/ruby/' -type d -name newrelic_rpm\\* -exec cp -r '{}' /instrumentation \\;"
RUN chmod -R go+r /instrumentation
RUN rm -rf /operator-build
