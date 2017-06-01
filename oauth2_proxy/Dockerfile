FROM gbolo/baseos:alpine

# ENVIRONMENT VARIABLES (don't reference other env, use arg vars)
ENV   OAUTH2_PROXY_VERSION=2.2 \
      OAUTH2_PROXY_SHA1=1c73bc38141e079441875e5ea5e1a1d6054b4f3b \
      OAUTH2_PROXY_ALLOWED_EMAILS_FILE=/data/allowed_emails.txt

# INSTALL
COPY install /tmp/install

RUN   set -xe; \
# install logic in script
      /bin/sh /tmp/install/setup.sh && \
      rm -rf /tmp/install

# EXPOSE AN ENTRY
EXPOSE      9000
ENTRYPOINT  ["/entrypoint.sh", "/usr/local/bin/dumb-init", "--", "oauth2_proxy"]
