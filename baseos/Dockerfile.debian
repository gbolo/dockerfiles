FROM  debian:stretch-slim

# ARGUMENTS
ARG   baseos=alpine-debian-stretch
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
      TINI_VERSION=0.16.1 \
      GOSU_VERSION=1.10 \
      CONFD_VERSION=0.16.0 \
      TZ=America/Toronto

# COPY BASE ENTRYPOINT
COPY  entrypoint-base.sh /entrypoints/entrypoint-base

RUN   set -xe; \
# upgrade all packages
      apt-get update && \
      apt-get upgrade -y && \
# install basics that we need
      DEBIAN_FRONTEND=noninteractive \
      apt-get install -y --no-install-recommends ca-certificates dumb-init tzdata openssl wget && \
# setup default timezone
      ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && \
      echo ${TZ} > /etc/timezone && \
# install tini as dumb-init alternative
      wget --no-verbose -O /sbin/tini "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini" && \
      chmod 755 /sbin/tini && \
# install gosu for user switching
      wget --no-verbose -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" && \
# install confd for config templating
      wget --no-verbose -O /usr/local/bin/confd "https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64" && \
# bins should be r+x
      chmod 555 /usr/local/bin/* && \
      chmod 555 /entrypoints/* && \
# clean up cache and deps
      apt-get remove -y openssl && \
      apt-get autoremove -y && \
      rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoints/entrypoint-base"]
