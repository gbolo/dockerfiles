# github.com/gbolo/dockerfiles/ghostunnel/Dockerfile

#
#  BUILD CONTAINER -------------------------------------------------------------
#

FROM gbolo/builder:alpine as builder

# Arguments
ARG   ghostunnel_version=master

# Building
RUN   set -xe; \
      SRC_DIR=${GOPATH}/src/github.com/square/ghostunnel; \
      SRC_REPO=https://github.com/square/ghostunnel; \
      mkdir -p ${SRC_DIR} && \
      git clone -b master --single-branch ${SRC_REPO} ${SRC_DIR} && \
      cd ${SRC_DIR}; \
      if [ "${ghostunnel_version}" != "master" ]; then git checkout ${ghostunnel_version}; fi && \
      go build -o /usr/local/bin/ghostunnel

#
#  FINAL BASE CONTAINER --------------------------------------------------------
#

FROM  gbolo/baseos:alpine

# Install prereqs
RUN   set -xe; \
      apk add --no-cache --update libltdl

# Copy in from builder
COPY  --from=builder /usr/local/bin/ghostunnel /usr/local/bin/ghostunnel

# override entry
ENTRYPOINT  ["/usr/local/bin/ghostunnel"]
CMD         ["--help"]
