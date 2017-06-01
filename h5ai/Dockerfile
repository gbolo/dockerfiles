FROM gbolo/baseos:alpine

# ENVIRONMENT VARIABLES (don't reference other env, use arg vars)
ENV   H5AI_VERSION=0.29.0 \
      H5AI_SHA1=336cf8df6811eeea9e6bac0666b3078a74b5b0ec \
      # default password is: changeme
      H5AI_PASSWORD=f1891cea80fc05e433c943254c6bdabc159577a02a7395dfebbfbc4f7661d4af56f2d372131a45936de40160007368a56ef216a30cb202c66d3145fd24380906

# INSTALL
COPY install /tmp/install

RUN   set -xe; \
# install logic in script
      /bin/sh /tmp/install/setup.sh && \
      rm -rf /tmp/install

# EXPOSE AN ENTRY
EXPOSE      9000
ENTRYPOINT  ["/entrypoint.sh", "/usr/local/bin/dumb-init", "--", "php-fpm7"]
CMD         ["--nodaemonize"]
