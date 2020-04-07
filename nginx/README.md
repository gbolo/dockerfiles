# Docker Image: [gbolo/nginx:alpine](https://hub.docker.com/r/gbolo/nginx/)

[![Docker Automated build](https://img.shields.io/docker/automated/gbolo/nginx.svg)]()
[![Docker Build Status](https://img.shields.io/docker/build/gbolo/nginx.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/gbolo/nginx.svg)]()

## Features

Light weight, Alpine based nginx docker image available at: [gbolo/nginx:alpine](https://hub.docker.com/r/gbolo/nginx/)

### gbolo/baseos:alpine base image
 - inherits all features found in [gbolo/baseos:alpine](https://hub.docker.com/r/gbolo/baseos)

### pre-installed nginx modules
 - `mod-stream` adds support for stream servers defined in `/etc/nginx/stream.conf.d/*.conf`
 - `mod-http-geoip2` adds geoip functionality for http servers
 - `mod-stream-geoip2` adds geoip functionality for stream servers

### templated nginx.conf
 - dynamically generated base `nginx.conf` based on the following environment variables:
 ```
 NGINX_WORKER_PROCESSES=auto
 NGINX_WORKER_CONNECTIONS=1024
 NGINX_MAX_BODY_SIZE=1m
 NGINX_KEEPALIVE_TIMEOUT=65
 NGINX_SSL_PROTOCOLS="TLSv1.2 TLSv1.3"
 NGINX_SSL_CIPHERS="AES256+EECDH:AES256+EDH:AES128+EECDH:CHACHA20+EECDH:!aNULL:!SHA1:!SHA256:!SHA384"
 NGINX_SSL_PREFER_SERVER_CIPHERS="off"
 NGINX_SSL_SESSION_CACHE="shared:SSL:2m"
 NGINX_SSL_SESSION_TIMEOUT=5m
 ```

### inotify support
This image comes with a custom entrypoint which supports auto reloading of nginx
when monitored files/directories are modified, moved, created, deleted.
The files/directories to watch can be modified by overriding the default environment variable:
 - `NGINX_INOTIFY_FILES="/etc/nginx/conf.d /etc/nginx/stream.conf.d"`

**PRO-TIP**: if your using an external method to update TLS certificates (ie: Let's Encrypt), include that directory above.

### secured TLS
 - strong default tls settings
 - included dhparam pem
 - *should* get an A rating on ssllabs.com

## NOTICE: GeoLite2 databases have been removed from this image
THIS FUNCTIONALITY HAS BEEN REMOVED DUE TO THE FOLLOWING CHANGES FROM MAXMIND:
> Starting December 30, 2019, we will be requiring users of our GeoLite2 databases
> to register for a MaxMind account and obtain a license key in order to download GeoLite2 databases

*Workaround: download the database with your own account, then mount it into the container*
