# This docker Image is for cross compiling binaries for s390x
# WARNING: This Image is for testing purposes only

FROM debian:stretch-slim

# LABELS
LABEL maintainer="George Bolo <gbolo@linuxctl.com>"

# ARGUMENTS
ARG   go_version=1.11.1

# ENVIRONMENT VARIABLES
ENV   GO_VERSION=${go_version} \
      GOROOT=/opt/go \
      GOPATH=/opt/gopath

ENV   PATH=${PATH}:${GOROOT}/bin:${GOPATH}/bin

# Duplicate deb line as deb-src
RUN cat /etc/apt/sources.list | sed "s/deb/deb-src/" >> /etc/apt/sources.list

# Add the s390x architecture
RUN dpkg --add-architecture s390x

# Grab the updated list of packages
RUN apt update && apt dist-upgrade -yy

# Install some build essentials
RUN apt install -yy build-essential clang
RUN apt install -yy gcc-multilib-s390x-linux-gnu binutils-multiarch

RUN DEBIAN_FRONTEND=noninteractive \
# install compile related packages
    apt-get install -y --no-install-recommends \
        libbz2-dev:s390x \
        liblzo2-dev:s390x \
        zlib1g-dev:s390x \
        libncursesw5-dev:s390x \
        libnfs-dev:s390x \
        librdmacm-dev:s390x \
        libsnappy-dev:s390x \
        libltdl-dev:s390x \
        libtool:s390x \
        libtool \
        libltdl-dev \
# non-compile related packages
        ca-certificates \
        curl \
        git \
        openssl \
        vim && \
# cleanup
  rm -rf /var/lib/apt/lists/*

# Install golang
RUN mkdir -p ${GOPATH} && \
    curl -sL -o /tmp/go.tgz https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -xf /tmp/go.tgz -C /opt/ && \
    rm -rf /tmp/go.tgz

ENTRYPOINT ["/bin/bash"]
