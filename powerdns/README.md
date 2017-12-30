# PowerDNS Docker Image: [gbolo/pdns:latest](https://hub.docker.com/r/gbolo/pdns/)

[![Docker Automated build](https://img.shields.io/docker/automated/gbolo/pdns.svg)]()
[![Docker Build Status](https://img.shields.io/docker/build/gbolo/pdns.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/gbolo/pdns.svg)]()

## Features

Light weight, Alpine based pdns (PowerDNS) docker image available at: [gbolo/pdns:latest](https://hub.docker.com/r/gbolo/pdns/)

### gbolo/baseos:alpine base image
 - inherits all features found in [gbolo/baseos:alpine](https://hub.docker.com/r/gbolo/baseos)

### templated configuration files
 - dynamically generated configs based on the following environment variables:
 ```
 # Available environment variables with their default values
 PDNS_LAUNCH="gsqlite3,bind"
 PDNS_THREADS=1
 PDNS_ENABLE_WEBSERVER=yes
 PDNS_WEBSERVER_PORT=8081
 PDNS_GSQLITE3_DATABASE=/etc/pdns/data/powerdns.sqlite3.db
 PDNS_ENABLE_API=yes
 PDNS_API_KEY=changeme
 ```
### automated configuration of `sqlite3` backend
 - automatically detected via `PDNS_LAUNCH` environment variable
 - database file can be specified with `PDNS_GSQLITE3_DATABASE` environment variable
 - database file is **automatically initialized** with schema when:
   * `PDNS_LAUNCH` is configured to use it **AND** `PDNS_GSQLITE3_DATABASE` does not already exist

### support for additional flags
additional flags to `pdns_server` can be specified at runtime with `CMD`. for example:
```
# additional flags can be added at runtime (--guardian=no)
docker run --name pdns \
  -p 1053:53 \
  -p 1053:53/udp \
  -e PDNS_LAUNCH=gsqlite3 \
  -e PDNS_ENABLE_API=no \
  gbolo/pdns \
    --guardian=no
```

## Example Usage
```
# run with API and webserver enabled, and sqlite3 backend
docker run --name pdns \
  -p 1053:53 \
  -p 1053:53/udp \
  -p 8081:8081 \
  -e PDNS_LAUNCH=gsqlite3 \
  -e PDNS_ENABLE_API=yes \
  -e PDNS_API_KEY=secret \
  gbolo/pdns
```
