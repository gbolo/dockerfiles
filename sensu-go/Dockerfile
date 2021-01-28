# github.com/gbolo/dockerfiles/lego/Dockerfile

#
#  BUILD CONTAINER -------------------------------------------------------------
#

FROM gbolo/builder:alpine as builder

# Arguments
ARG   sensu_version=v6.0.0

# Building
RUN   set -xe; \
      git clone -b master --single-branch https://github.com/sensu/sensu-go.git && \
      cd sensu-go; \
      if [ "${sensu_version}" != "master" ]; then git checkout ${sensu_version}; fi && \
      go build -ldflags '-X "github.com/sensu/sensu-go/version.Version=${sensu_version}" -X "github.com/sensu/sensu-go/version.BuildDate=`date +%F`" -X "github.com/sensu/sensu-go/version.BuildSHA='`git rev-parse HEAD`'"' -o /usr/local/bin/sensu-agent ./cmd/sensu-agent &&\
      go build -ldflags '-X "github.com/sensu/sensu-go/version.Version=${sensu_version}" -X "github.com/sensu/sensu-go/version.BuildDate=`date +%F`" -X "github.com/sensu/sensu-go/version.BuildSHA='`git rev-parse HEAD`'"' -o /usr/local/bin/sensu-backend ./cmd/sensu-backend &&\
      go build -ldflags '-X "github.com/sensu/sensu-go/version.Version=${sensu_version}" -X "github.com/sensu/sensu-go/version.BuildDate=`date +%F`" -X "github.com/sensu/sensu-go/version.BuildSHA='`git rev-parse HEAD`'"' -o /usr/local/bin/sensuctl ./cmd/sensuctl

#
#  FINAL BASE CONTAINER --------------------------------------------------------
#

FROM  gbolo/baseos:alpine

# Copy in from builder
COPY  --from=builder /usr/local/bin/sensu* /usr/local/bin/

# install some stuff
RUN   apk add --no-cache bash

# Run as non-privileged user by default
#USER  65534

# Inherit gbolo/baseos entrypoint and pass it this argument
#ENTRYPOINT  ["/usr/local/bin/lego"]
