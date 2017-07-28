# Dockerfile for compiling Hyperledger Fabric binaries for RHEL7 based systems
# Use as an aid for compiling fabric in your automation process
# WARNING: USE AT YOUR OWN RISK!

FROM centos:7

# ARGUMENTS
ARG   basechangedate=2017-06-25
ARG   baseos=centos-7
ARG   purpose=compile
ARG   project=hyperledger-fabric
ARG   goversion=1.8.3
ARG   goroot=/opt/go
ARG   gopath=/opt/gopath

# LABELS
LABEL maintainer="George Bolo <gbolo@linuxctl.com>" \
      vendor="linuxctl.com" \
      com.linuxctl.baseos=${baseos} \
      com.linuxctl.basechangedate=${basechangedate} \
      com.linuxctl.purpose=${purpose} \
      com.linuxctl.project=${project}

# ENVIRONMENT VARIABLES (don't reference other env, use arg vars)
ENV   BASE_OS=${baseos} \
      BASE_CHANGE_DATE=${basechangedate} \
      IMAGE_PURPOSE=${purpose} \
      IMAGE_PROJECT=${project} \
      GO_URL=https://storage.googleapis.com/golang/go${goversion}.linux-amd64.tar.gz \
      GOROOT=${goroot} \
      GOPATH=${gopath} \
      PATH=${PATH}:${gopath}/bin:${goroot}/bin

# INSTALL BUILD DEPENDENCIES
RUN   set -xe; \
      yum install -y gcc gcc-c++ autoconf automake unzip binutils make patch git \
        libtool libtool-ltdl-devel zlib zlib-devel bzip2 bzip2-devel \
        glibc-static libstdc++-static && \
      yum clean all && \
# INSTALL GO
      mkdir -p ${GOROOT} ${GOPATH} && \
      curl -o /tmp/go.tar.gz ${GO_URL} && \
      tar -xvzf /tmp/go.tar.gz -C /opt/ && \
      rm -rf /tmp/go.tar.gz && \
# FIX LIBTOOL
      curl -L -o /tmp/libtool.tgz http://ftpmirror.gnu.org/libtool/libtool-2.4.2.tar.gz && \
      tar -xvzf /tmp/libtool.tgz && \
      rm -rf /tmp/libtool.tgz && \
      cd libtool-2.4.2 && ./configure && make -j4 && \
      cp libltdl/.libs/libltdl.a /usr/lib64/ && cd - && \
      rm -rf libtool-2.4.2
