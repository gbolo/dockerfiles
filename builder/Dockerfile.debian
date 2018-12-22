# github.com/gbolo/dockerfiles/builder/Dockerfile.debian

FROM  gbolo/baseos:debian

# ARGS
ARG     go_version=1.11.4

# DEFAULTS
ENV     GOROOT=/opt/go \
        GOPATH=/opt/gopath

ENV     PATH=${PATH}:${GOPATH}/bin:${GOROOT}/bin

# SETUP DEV TOOLS
RUN     set -xe; \
# upgrade all packages
        apt-get update && \
        apt-get upgrade -y && \
# install everything we may want (it's OK to repeat pkgs!)
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y --no-install-recommends build-essential gnupg \
           git gcc libtool file libssl-dev openssl patch make curl ca-certificates \
           g++ python python3 python-dev python3-dev python-pip python3-pip php-cli && \
        # nodejs
        curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
        apt-get install -y --no-install-recommends nodejs && \
        # go
        GO_URL=https://storage.googleapis.com/golang/go${go_version}.linux-amd64.tar.gz; \
        curl -sL -o /tmp/go.tgz ${GO_URL} && \
        tar -xf /tmp/go.tgz -C /opt/ && rm -rf /tmp/go.tgz && \
        mkdir -p ${GOPATH} && \
# clean up
        apt-get autoremove -y && \
        rm -rf /var/lib/apt/lists/*

ENTRYPOINT  ["/bin/bash"]
