# github.com/gbolo/dockerfiles/powerdns/Dockerfile

FROM  gbolo/baseos:alpine

# Configurable defaults
ENV   PDNS_LAUNCH="gsqlite3,bind" \
      PDNS_THREADS=1 \
      PDNS_ENABLE_WEBSERVER=yes \
      PDNS_WEBSERVER_PORT=8081 \
      PDNS_GSQLITE3_DATABASE=/etc/pdns/data/powerdns.sqlite3.db \
      PDNS_ENABLE_API=yes \
      PDNS_API_KEY=changeme

# Install prereqs
RUN   set -xe; \
      apk add --no-cache --update pdns pdns-backend-sqlite3 pdns-backend-mysql \
         pdns-backend-pgsql pdns-backend-bind pdns-backend-pipe && \
      mkdir -p /etc/pdns/conf.d


# Copy in required files
COPY  confd /etc/confd.pdns
COPY  entrypoint.sh /entrypoints/entrypoint-pdns
COPY  schemas /etc/pdns/schemas

EXPOSE      53/udp 53/tcp ${PDNS_WEBSERVER_PORT}/tcp

ENTRYPOINT  ["/usr/bin/dumb-init", "--single-child", "--", "/entrypoints/entrypoint-pdns"]
CMD         ["--cache-ttl=120"]
