# Docker Image: [gbolo/digitalocean-ddns:latest](https://hub.docker.com/r/gbolo/digitalocean-ddns/)

[![Docker Automated build](https://img.shields.io/docker/automated/gbolo/digitalocean-ddns.svg)]()
[![Docker Build Status](https://img.shields.io/docker/build/gbolo/digitalocean-ddns.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/gbolo/digitalocean-ddns.svg)]()

## Features

A light-weight dynamic DNS updater for DigitalOcean based on the project [github.com/gesquive/digitalocean-ddns](https://github.com/gesquive/digitalocean-ddns). docker image available at: [gbolo/digitalocean-ddns:latest](https://hub.docker.com/r/gbolo/digitalocean-ddns/)

### gbolo/baseos:alpine base image
 - inherits all features found in [gbolo/baseos:debian](https://hub.docker.com/r/gbolo/baseos)

### Example Usage
```
docker run -it --rm \
 -e DODDNS_TOKEN=<your_do_api_access_token> \
 -e DODDNS_DOMAIN=testrecord.linuxctl.com \
 gbolo/digitalocean-ddns

> Executed entrypoint-base on: Sun Aug 19 17:12:22 UTC 2018
> Version Information:
BASEOS_BUILD_DATE=2018-06-01
BASEOS_BUILD_REF=3f0d121
> Executing as uid [65534]: /usr/local/bin/digitalocean-ddns
[2018-08-19T17:12:22Z]  INFO config: file=/etc/digitalocean-ddns/config.yml
[2018-08-19T17:12:22Z]  INFO service: run as service every 1h0m0s
[2018-08-19T17:12:22Z]  INFO ipchk: using 'https://linuxctl.com/ip' for ip check
[2018-08-19T17:12:22Z]  INFO sync: got public IP address=[_REMOVED_]
[2018-08-19T17:12:23Z]  INFO sync: no matching record found, will attempt to create
[2018-08-19T17:12:23Z]  INFO sync: new record successfully created
```
