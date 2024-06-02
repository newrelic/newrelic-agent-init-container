# To build one auto-instrumentation image for Java, please:
#  - Download the newrelic java agent jar file to `/newrelic-agent.jar` using the java-agent-download.sh.
#    This is required as when instrumenting the pod, one init container will be created to copy the jar to your app's container.
#  - Grant the necessary access to the jar. `chmod -R go+r /newrelic-agent.jar`
FROM busybox
ARG version

# Copy shell script to image
COPY java-agent-download.sh /
# Set executable permissions on shell script
RUN chmod +x /java-agent-download.sh
# Execute shell script to download agent, passing the version build arg to it
RUN /java-agent-download.sh $version
# Remove script from image when it's no longer needed
RUN rm /java-agent-download.sh
# Set executable permissions on Java agent jar file
RUN chmod -R go+r /newrelic-agent.jar
