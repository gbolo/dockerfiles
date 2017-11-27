FROM alpine:3.6

# ARGUMENTS
ARG   baseos=alpine-3.6
ARG   baseos_build_date=undefined
ARG   baseos_build_ref=undefined

# LABELS
LABEL maintainer="George Bolo <gbolo@linuxctl.com>" \
      vendor="linuxctl.com" \
      com.linuxctl.baseos=${baseos} \
      com.linuxctl.baseos.build-date=${baseos_build_date} \
      com.linuxctl.baseos.build-ref=${baseos_build_ref}

# ENVIRONMENT VARIABLES (don't reference other env, use arg vars)
ENV   BASEOS=${baseos} \
      BASEOS_BUILD_DATE=${baseos_build_date} \
      BASEOS_BUILD_REF=${baseos_build_ref} \
      GOSU_VERSION=1.10 \
      CONFD_VERSION=0.14.0

# COPY BASE ENTRYPOINT
COPY  entrypoint-base.sh /entrypoints/entrypoint-base

RUN   set -xe; \
# upgrade all packages
      apk upgrade --no-progress --no-cache && \
# nsswitch.conf is needed to make the golang apps respect /ect/hosts
      echo 'hosts: files dns' > /etc/nsswitch.conf && \
# install some basics that make sense in a base image
      apk add --no-cache ca-certificates openssl dumb-init && \
      update-ca-certificates && \
# install gosu for user switching
      wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" && \
# install confd for config templating
      wget -O /usr/local/bin/confd "https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64" && \
# bins should be r+x
      chmod 555 /usr/local/bin/* && \
      chmod 555 /entrypoints/* && \
# remove deps
      apk del openssl

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoints/entrypoint-base"]
