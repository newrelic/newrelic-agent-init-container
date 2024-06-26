# Build Python Instrumentation Files
FROM python:3.10-alpine@sha256:7e73eab259b777c76ad93e42180d468f326eff315c212bc80d4dffdf4695163a AS build

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
ENV NEW_RELIC_EXTENSIONS False
ENV WRAPT_DISABLE_EXTENSIONS True
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
FROM busybox:latest@sha256:9ae97d36d26566ff84e8893c64a6dc4fe8ca6d1144bf5b87b2b85a32def253c7

COPY --from=build /operator-build/workspace /instrumentation
RUN chmod -R go+r /instrumentation
