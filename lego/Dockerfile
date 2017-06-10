FROM gbolo/baseos:alpine

# ENVIRONMENT VARIABLES (don't reference other env, use arg vars)
ENV   LEGO_VERSION=0.3.1 \
      LEGO_SHA1=4d4bf70f6f4dcd455a426f5eef975fdb040aaf1b

# INSTALL
COPY install /tmp/install

RUN   set -xe; \
# install logic in script
      /bin/sh /tmp/install/setup.sh && \
      rm -rf /tmp/install

# EXPOSE AN ENTRY
EXPOSE      80 443
ENTRYPOINT  ["/entrypoint.sh", "/usr/local/bin/dumb-init", "--", "lego"]
