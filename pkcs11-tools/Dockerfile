FROM    gbolo/baseos:debian

# LABELS
LABEL maintainer="George Bolo <gbolo@linuxctl.com>"

# CONFIGURABLE DEFAULTS
ARG     go_version=1.10.1

ENV     GO_VERSION=${go_version} \
        GOROOT=/opt/go \
        GOPATH=/opt/gopath \
        PATH=${PATH}:/opt/go/bin:/opt/gopath/bin

# INSTALL VARIOUS PKCS11 TOOLS
RUN     set -xe; \
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y --no-install-recommends softhsm2 git build-essential cmake libssl-dev libseccomp-dev curl libtool libltdl-dev && \
        mkdir -p /var/lib/softhsm/tokens && \
        rm -rf /var/lib/apt/lists/* && \
        git clone https://github.com/SUNET/pkcs11-proxy /tmp/pkcs11-proxy && \
        cd /tmp/pkcs11-proxy && cmake . && make && make install && \
        rm -rf /tmp/pkcs11-proxy

# INSTALL VARIOUS PKCS11 TOOLS
RUN     mkdir -p ${GOPATH} && \
        curl -sL -o /tmp/go.tgz https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz && \
        tar -xf /tmp/go.tgz -C /opt/ && \
        rm -rf /tmp/go.tgz && \
        go get github.com/gbolo/go-util/p11tool && \
        go get github.com/gbolo/go-util/pkcs11-test && \
        go get github.com/scottallan/p11tool-new
