FROM    gbolo/baseos:alpine

# CONFIGURABLE DEFAULTS
ENV     NGINX_WORKER_PROCESSES=auto \
        NGINX_WORKER_CONNECTIONS=1024 \
        NGINX_MAX_BODY_SIZE=1m \
        NGINX_KEEPALIVE_TIMEOUT=65 \
        NGINX_SSL_PROTOCOLS="TLSv1.2 TLSv1.3" \
        NGINX_SSL_CIPHERS="AES256+EECDH:AES256+EDH:AES128+EECDH:CHACHA20+EECDH:!aNULL:!SHA1:!SHA256:!SHA384" \
        NGINX_SSL_PREFER_SERVER_CIPHERS="off" \
        NGINX_SSL_SESSION_CACHE="shared:SSL:2m" \
        NGINX_SSL_SESSION_TIMEOUT=5m \
        NGINX_INOTIFY_FILES="/etc/nginx/conf.d /etc/nginx/stream.conf.d"

# INSTALL NGINX
RUN     set -xe; \
# upgrade all packages
        apk upgrade --no-progress --no-cache && \
# setup nginx and other software
        apk add -v --no-progress --no-cache nginx \
          nginx-mod-stream \
          nginx-mod-http-geoip2 nginx-mod-stream-geoip2 \
          inotify-tools && \
        mkdir -p /etc/tls/nginx /etc/nginx/stream.conf.d && \
        chmod 750 /etc/tls/nginx && \
        chmod 755 /etc/nginx/stream.conf.d && \
# forward request and error logs to docker log collector
        ln -sf /dev/stdout /var/log/nginx/access.log && \
        ln -sf /dev/stderr /var/log/nginx/error.log && \
# clean up defaults
        rm -rf /etc/nginx/conf.d/*

# ADD AN IMAGE LAYER FOR GEOIP COUNTRY DATABASE
# LICENSE: This image includes GeoLite2 data created by MaxMind, available from https://www.maxmind.com
#### THIS FUNCTIONALITY HAS BEEN REMOVED DUE TO THE FOLLOWING CHANGES FROM MAXMIND:
####  > Starting December 30, 2019, we will be requiring users of our GeoLite2 databases
####  > to register for a MaxMind account and obtain a license key in order to download GeoLite2 databases
#RUN     set -xe; \
#        wget -O /tmp/geo.tgz https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz && \
#        tar xf /tmp/geo.tgz -C /usr/share/GeoIP --strip 1 && \
#        rm -rf /tmp/geo.tgz

# COPY REQUIRED FILES
COPY    confd /etc/confd.nginx
COPY    default_dhparam_4096.pem /etc/tls/nginx/default_dhparam_4096.pem
COPY    entrypoint.sh /entrypoints/entrypoint-nginx

EXPOSE  80 443

ENTRYPOINT  ["/usr/bin/dumb-init", "--", "/entrypoints/entrypoint-nginx"]
