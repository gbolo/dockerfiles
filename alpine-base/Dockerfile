FROM alpine:3.6

# ARGUMENTS
ARG   basedate=2017-05-27
ARG   baseos=alpine-3.6

# LABELS
LABEL maintainer="George Bolo <gbolo@linuxctl.com>" \
      vendor="linuxctl.com" \
      com.linuxctl.baseos=${baseos} \
      com.linuxctl.basedate=${basedate}

# ENVIRONMENT VARIABLES (don't reference other env, use arg vars)
ENV   BASE_OS=${baseos} \
      BASE_DATE=${basedate} \
      GOSU_VERSION=1.10 \
      CONFD_VERSION=0.11.0

# INSTALL SOME BASE BINS: dumb-init
COPY  bin/* /usr/local/bin/

RUN   set -xe; \
# nsswitch.conf is needed to make the golang apps respect /ect/hosts
      echo 'hosts: files dns' > /etc/nsswitch.conf && \
# install root ca certificates and openssl
      apk add --no-cache ca-certificates openssl && \
      update-ca-certificates && \
# install gosu for user switching
      wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" && \
# install confd for config templating
      wget -O /usr/local/bin/confd "https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64" && \
# bins should be r+x
      chmod 555 /usr/local/bin/* && \
# remove deps
      apk del openssl
