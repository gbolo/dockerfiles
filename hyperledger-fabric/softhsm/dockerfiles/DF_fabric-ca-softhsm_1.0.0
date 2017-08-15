# This is for testing softhsm integration

FROM debian:buster-slim

# LABELS
LABEL maintainer="George Bolo <gbolo@linuxctl.com>"

# ARGUMENTS
ARG   baseimage_release=0.3.1
ARG   project_version=1.0.0
ARG   go_version=1.7.6

# ENVIRONMENT VARIABLES (don't reference other env, use arg vars)
ENV   GO_VERSION=${go_version} \
      PROJECT_VERSION=${project_version} \
      BASE_VERSION=${project_version} \
      FABRIC_TAG=v${project_version} \
      FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server \
      BASEIMAGE_RELEASE=${baseimage_release} \
      DAEMON_TYPE=ca

# INSTALL
COPY install /tmp/install

RUN   set -xe; \
# install logic in script
      /bin/bash -xe /tmp/install/setup.sh ca && \
      rm -rf /tmp/install

# ENTRY
CMD ["bash", "-c", "fabric-ca-server start -b admin:adminpw"]
