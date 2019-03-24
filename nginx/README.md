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
 - `mod-http-geoip` adds geoip functionality for http servers
 - `mod-stream-geoip` adds geoip functionality for stream servers

### templated nginx.conf
 - dynamically generated base `nginx.conf` based on the following environment variables:
 ```
 NGINX_WORKER_PROCESSES=auto
 NGINX_WORKER_CONNECTIONS=1024
 NGINX_MAX_BODY_SIZE=1m
 NGINX_KEEPALIVE_TIMEOUT=65
 NGINX_SSL_PROTOCOLS="TLSv1.1 TLSv1.2"
 NGINX_SSL_CIPHERS="EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH:!aNULL:!MD5"
 NGINX_SSL_SESSION_CACHE="shared:SSL:2m"
 NGINX_SSL_SESSION_TIMEOUT=5m
 ```

### inotify support
This image comes with a custom entrypoint which supports auto reloading of nginx
when monitored files/directories are modified, moved, created, deleted.
The files/directories to watch can be modified by overriding the default environment variable:
 - `NGINX_INOTIFY_FILES="/etc/nginx/conf.d /etc/nginx/stream.conf.d"`

**PRO-TIP**: if your using an external method to update TLS certificates (ie: Let's Encrypt), include that directory above.

### secured tls
 - strong default tls settings
 - included dhparam pem

## MaxMind GEOIP LICENSE
This docker image includes GeoLite2 data created by MaxMind, available from
[https://www.maxmind.com](https://www.maxmind.com)
