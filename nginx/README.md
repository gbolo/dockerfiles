# Docker Image: [gbolo/nginx:alpine](https://hub.docker.com/r/gbolo/nginx/)

[![Docker Automated build](https://img.shields.io/docker/automated/gbolo/nginx.svg)]()
[![Docker Build Status](https://img.shields.io/docker/build/gbolo/nginx.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/gbolo/nginx.svg)]()

## Features

Light weight, Alpine based nginx docker image available at: [gbolo/nginx:alpine](https://hub.docker.com/r/gbolo/nginx/)

### gbolo/baseos:alpine base image
 - inherits all features found in [gbolo/baseos:alpine](https://hub.docker.com/r/gbolo/baseos)

### templated nginx.conf
 - dynamically generated nginx.conf based on the following environment variables:
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

### secured tls
 - strong default tls settings
 - included dhparam pem
