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
      FABRIC_CA_CLIENT_HOME=/etc/hyperledger/fabric/client \
      FABRIC_CA_CLIENT_URL=http://gbolo:testing@ca.fabric.linuxctl.com \
      FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/fabric/msp \
      FABRIC_CA_CLIENT_CSR_CN=peerX.fabric.linuxctl.com \
      FABRIC_CA_CLIENT_CSR_HOSTS=peerX.fabric.linuxctl.com \
      ORDERER_GENERAL_LOCALMSPDIR=/etc/hyperledger/fabric/msp \
      ORDERER_GENERAL_LISTENADDRESS=0.0.0.0 \
      DAEMON_TYPE=orderer

# INSTALL
COPY install /tmp/install

RUN   set -xe; \
# install logic in script
      /bin/bash -xe /tmp/install/setup.sh orderer ${patch} && \
      rm -rf /tmp/install

# ENTRY
CMD ["/usr/local/bin/entrypoint.sh", "orderer", "start"]
