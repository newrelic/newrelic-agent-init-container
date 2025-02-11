# To build one auto-instrumentation image for Java, please:
#  - Download the newrelic java agent jar file to `/newrelic-agent.jar` using the java-agent-download.sh.
#    This is required as when instrumenting the pod, one init container will be created to copy the jar to your app's container.
#  - Grant the necessary access to the jar. `chmod -R go+r /newrelic-agent.jar`
FROM alpine:latest@sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0 as build
RUN apk update && apk add ca-certificates
WORKDIR /instrumentation

# Copy shell script to image
COPY java-agent-download.sh /
# Set executable permissions on shell script
RUN chmod +x /java-agent-download.sh
# Execute shell script to download agent, passing the version build arg to it
ARG AGENT_VERSION
RUN /java-agent-download.sh $AGENT_VERSION

FROM busybox:stable@sha256:71b79694b71639e633452f57fd9de40595d524de308349218d9a6a144b40be02
COPY --from=build /newrelic-agent.jar /newrelic-agent.jar
# Set executable permissions on Java agent jar file
RUN chmod -R go+r /newrelic-agent.jar
