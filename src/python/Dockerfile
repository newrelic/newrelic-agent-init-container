ARG RUNTIME_VERSION=3.12-alpine@sha256:0bd77ae937dce9037e136ab35f41eaf9e012cfd741fc3c8dd4b3e2b63499f12c
FROM python:$RUNTIME_VERSION AS build

WORKDIR /operator-build

# Install dependencies
COPY requirements-builder.txt .
RUN pip install -r requirements-builder.txt

# Download and prepare wheels
ARG AGENT_VERSION
ENV AGENT_VERSION=${AGENT_VERSION}
COPY download_wheels.py .
RUN python ./download_wheels.py

# Install sdist without extensions to set up the directory
ENV NEW_RELIC_EXTENSIONS=False
ENV WRAPT_DISABLE_EXTENSIONS=True
RUN pip install ./workspace/newrelic.tar.gz --target=./workspace/newrelic && \
    rm ./workspace/newrelic.tar.gz

# Install pip as a vendored package
COPY requirements-vendor.txt .
RUN mkdir -p ./workspace/vendor && \
    pip install --target=./workspace/vendor -r requirements-vendor.txt

# Install sitecustomize and newrelic_k8s_operator modules
RUN cp ./workspace/newrelic/newrelic/bootstrap/sitecustomize.py ./workspace/sitecustomize.py
COPY newrelic_k8s_operator.py ./workspace/

# Package Init Container
FROM busybox:stable@sha256:851281100cc5f93d8a8f8e1a8976a57ec40a9bc9edd66ad3a621e4aa63326915

COPY --from=build /operator-build/workspace /instrumentation
RUN chmod -R go+r /instrumentation
