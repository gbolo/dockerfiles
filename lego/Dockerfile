FROM gbolo/baseos:alpine

# ENVIRONMENT VARIABLES (don't reference other env, use arg vars)
ENV   LEGO_VERSION=0.4.0 \
      LEGO_SHA1=8ecfefccb5abbddbd2d220c490ad9df90bbabe7d

# INSTALL
COPY install /tmp/install

RUN   set -xe; \
# install logic in script
      /bin/sh /tmp/install/setup.sh && \
      rm -rf /tmp/install

# EXPOSE AN ENTRY
EXPOSE      80 443
ENTRYPOINT  ["/entrypoint.sh", "/usr/local/bin/dumb-init", "--", "lego"]
