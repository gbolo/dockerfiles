# Docker Image: [gbolo/baseos:alpine](https://hub.docker.com/r/gbolo/baseos/)

[![Docker Automated build](https://img.shields.io/docker/automated/gbolo/baseos.svg)]()
[![Docker Build Status](https://img.shields.io/docker/build/gbolo/baseos.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/gbolo/baseos.svg)]()

## Features

Light weight, Alpine based docker image available at: [gbolo/baseos:alpine](https://hub.docker.com/r/gbolo/baseos/)

### entrypoint-base
 - comes with default entrypoint script which executes most of the features below, which can be reused in other images

### confd
 - confd installed by default at `/usr/local/bin/confd`

### dumb-init
 - dumb-init installed by default at `/usr/bin/dumb-init`

### update-ca-certificates
 - easily update root certificates

### gosu
 - ability to `su` without a `TTY`!

### timezone is configurable
 - TZ data is installed and configurable through env var `TZ`

### nsswitch.conf
 - preconfigured `/etc/nsswitch.conf`

### informational ENV vars
 - `$BASEOS_BUILD_DATE` - set to date of image build and also patch level date
 - `$BASEOS_BUILD_REF` - set to git repo commit hash used for build

## Entrypoint

The entrypoint script is intended to be executed by other entrypoint scripts
to provide basic functionality which does not need to be repeated.
