# github.com/gbolo/dockerfiles/digitalocean-ddns/Dockerfile

#
#  BUILD CONTAINER -------------------------------------------------------------
#

FROM gbolo/builder:alpine as builder

# Arguments
ARG   do_ddns_version=master

# Building
RUN   set -xe; \
      SRC_DIR=${GOPATH}/src/github.com/gesquive/digitalocean-ddns; \
      SRC_REPO=https://github.com/gesquive/digitalocean-ddns; \
      mkdir -p ${SRC_DIR} && \
      git clone -b master --single-branch ${SRC_REPO} ${SRC_DIR} && \
      cd ${SRC_DIR}; \
      if [ "${do_ddns_version}" != "master" ]; then git checkout ${do_ddns_version}; fi && \
      make deps && make install

#
#  FINAL BASE CONTAINER --------------------------------------------------------
#

FROM  gbolo/baseos:alpine

# ENVIRONMENT VARIABLES
ENV   DODDNS_URL_LIST=https://linuxctl.com/ip

# Copy in from builder
COPY  --from=builder /usr/local/bin/digitalocean-ddns /usr/local/bin/digitalocean-ddns

# Run as non-privileged user by default
USER  65534

# Inherit gbolo/baseos entrypoint and pass it this argument
CMD  ["/usr/local/bin/digitalocean-ddns"]
