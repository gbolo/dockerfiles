# This is for testing softhsm integration

FROM debian:buster-slim

# LABELS
LABEL maintainer="George Bolo <gbolo@linuxctl.com>"

# ARGUMENTS
ARG   baseimage_release=0.3.1
ARG   project_version=1.0.0
ARG   go_version=1.7.6
ARG   patch=nopatch

# ENVIRONMENT VARIABLES (don't reference other env, use arg vars)
ENV   GO_VERSION=${go_version} \
      PROJECT_VERSION=${project_version} \
      BASE_VERSION=${project_version} \
      FABRIC_TAG=v${project_version} \
      FABRIC_CFG_PATH=/etc/hyperledger/fabric \
      BASEIMAGE_RELEASE=${baseimage_release} \
      GOPATH=/opt/gopath \
      GOROOT=/opt/go

ENV   PATH=${PATH}:/opt/go/bin

# INSTALL
COPY install /tmp/install

RUN   set -xe; \
# install logic in script
      /bin/bash -xe /tmp/install/setup.sh tools ${patch} && \
      rm -rf /tmp/install

# ENTRY
CMD ["/bin/bash"]
