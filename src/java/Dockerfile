# To build one auto-instrumentation image for Java, please:
#  - Download the newrelic java agent jar file to `/newrelic-agent.jar` using the java-agent-download.sh.
#    This is required as when instrumenting the pod, one init container will be created to copy the jar to your app's container.
#  - Grant the necessary access to the jar. `chmod -R go+r /newrelic-agent.jar`
FROM alpine:latest@sha256:21dc6063fd678b478f57c0e13f47560d0ea4eeba26dfc947b2a4f81f686b9f45 as build
RUN apk update && apk add ca-certificates
WORKDIR /instrumentation

# Copy shell script to image
COPY java-agent-download.sh /
# Set executable permissions on shell script
RUN chmod +x /java-agent-download.sh
# Execute shell script to download agent, passing the version build arg to it
ARG AGENT_VERSION
RUN /java-agent-download.sh $AGENT_VERSION

FROM busybox:stable@sha256:7c3c3cea5d4d6133d6a694d23382f6a7b32652f23855abdba3eb039ca5995447
COPY --from=build /newrelic-agent.jar /newrelic-agent.jar
# Set executable permissions on Java agent jar file
RUN chmod -R go+r /newrelic-agent.jar
