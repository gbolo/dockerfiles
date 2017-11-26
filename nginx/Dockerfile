FROM    gbolo/baseos:alpine

# CONFIGURABLE DEFAULTS
ENV     NGINX_WORKER_PROCESSES=auto \
        NGINX_WORKER_CONNECTIONS=1024 \
        NGINX_MAX_BODY_SIZE=1m \
        NGINX_KEEPALIVE_TIMEOUT=65 \
        NGINX_SSL_PROTOCOLS="TLSv1.1 TLSv1.2" \
        NGINX_SSL_CIPHERS="EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH:!aNULL:!MD5" \
        NGINX_SSL_SESSION_CACHE="shared:SSL:2m" \
        NGINX_SSL_SESSION_TIMEOUT=5m

# INSTALL NGINX
RUN     set -xe; \
# upgrade all packages
        apk upgrade --no-progress --no-cache && \
# setup nginx
        apk add -v --no-progress --no-cache nginx && \
        mkdir -p /etc/tls/nginx && \
        chmod 750 /etc/tls/nginx && \
# forward request and error logs to docker log collector
        ln -sf /dev/stdout /var/log/nginx/access.log && \
        ln -sf /dev/stderr /var/log/nginx/error.log && \
# clean up defaults
        rm -rf /etc/nginx/conf.d/*

# COPY REQUIRED FILES
COPY    confd /etc/confd.nginx
COPY    default_dhparam_4096.pem /etc/tls/nginx/default_dhparam_4096.pem
COPY    entrypoint.sh /entrypoint

EXPOSE  80 443

ENTRYPOINT  ["/entrypoint"]
CMD         ["nginx", "-g", "daemon off;"]
