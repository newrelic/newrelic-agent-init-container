# To build one auto-instrumentation image for Java, please:
#  - Download the newrelic java agent jar file to `/newrelic-agent.jar` using the java-agent-download.sh.
#    This is required as when instrumenting the pod, one init container will be created to copy the jar to your app's container.
#  - Grant the necessary access to the jar. `chmod -R go+r /newrelic-agent.jar`
FROM alpine:latest@sha256:77726ef6b57ddf65bb551896826ec38bc3e53f75cdde31354fbffb4f25238ebd as build
RUN apk update && apk add ca-certificates
WORKDIR /instrumentation

# Copy shell script to image
COPY java-agent-download.sh /
# Set executable permissions on shell script
RUN chmod +x /java-agent-download.sh
# Execute shell script to download agent, passing the version build arg to it
ARG AGENT_VERSION
RUN /java-agent-download.sh $AGENT_VERSION

FROM busybox:latest@sha256:9ae97d36d26566ff84e8893c64a6dc4fe8ca6d1144bf5b87b2b85a32def253c7
COPY --from=build /newrelic-agent.jar /newrelic-agent.jar
# Set executable permissions on Java agent jar file
RUN chmod -R go+r /newrelic-agent.jar
