# github.com/gbolo/dockerfiles/lego/Dockerfile

#
#  BUILD CONTAINER -------------------------------------------------------------
#

FROM gbolo/builder:alpine as builder

# Arguments
ARG   lego_version=v3.2.0

# Building
RUN   set -xe; \
      SRC_DIR=${GOPATH}/src/github.com/xenolf/lego; \
      SRC_REPO=https://github.com/xenolf/lego; \
      mkdir -p ${SRC_DIR} && \
      git clone -b master --single-branch ${SRC_REPO} ${SRC_DIR} && \
      cd ${SRC_DIR}; \
      if [ "${lego_version}" != "master" ]; then git checkout ${lego_version}; fi && \
      make build && mv dist/lego /usr/local/bin/lego

#
#  FINAL BASE CONTAINER --------------------------------------------------------
#

FROM  gbolo/baseos:alpine

# Copy in from builder
COPY  --from=builder /usr/local/bin/lego /usr/local/bin/lego

# Run as non-privileged user by default
USER  65534

# Inherit gbolo/baseos entrypoint and pass it this argument
ENTRYPOINT  ["/usr/local/bin/lego"]
