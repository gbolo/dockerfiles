# Docker Image: [gbolo/hsm-pkcs11proxy:latest](https://hub.docker.com/r/gbolo/hsm-pkcs11proxy/)

[![Docker Automated build](https://img.shields.io/docker/automated/gbolo/hsm-pkcs11proxy.svg)]()
[![Docker Build Status](https://img.shields.io/docker/build/gbolo/hsm-pkcs11proxy.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/gbolo/hsm-pkcs11proxy.svg)]()

## Features

Light weight HSM based on [pkcs11-proxy](https://github.com/SUNET/pkcs11-proxy) (and softhsm2) docker image available at: [gbolo/hsm-pkcs11proxy:latest](https://hub.docker.com/r/gbolo/hsm-pkcs11proxy/)

### gbolo/baseos:debian base image
 - inherits all features found in [gbolo/baseos:debian](https://hub.docker.com/r/gbolo/baseos)

### Dynamic init of softhsm slot
 - dynamically creation of softhsm2 slot based on the following environment variables:
```
 PKCS11_SLOT_LABEL=someLabel
 PKCS11_SLOT_PIN=somePin
 PKCS11_SO_PIN=1234
```

### Example Usage
```
docker run -it --rm \
 -e PKCS11_SLOT_LABEL=fabric \
 -e PKCS11_SLOT_PIN=secret \
 gbolo/hsm-pkcs11proxy

 > Executed entrypoint-base on: Tue Jan 30 14:34:27 EST 2018
 > Version Information:
 BASEOS_BUILD_DATE=2018-01-10
 BASEOS_BUILD_REF=3b0f440
 !! Exiting entrypoint-base
 > Executed entrypoint-pkcs11-proxy on: Tue Jan 30 14:34:27 EST 2018
 > pkcs11-proxy environment variables:
 PKCS11_SO_PIN=1234
 PKCS11_SLOT_PIN=secret
 PKCS11_SLOT_LABEL=fabric
 PKCS11_DAEMON_SOCKET=tcp://0.0.0.0:5657
 > Initializing softhsm2 slot: fabric
 Slot 0 has a free/uninitialized token.
 The token has been initialized.
 > Executing as uid [0]: /usr/local/bin/pkcs11-daemon /usr/lib/softhsm/libsofthsm2.so
 pkcs11-proxy[7]: Listening on: tcp://0.0.0.0:5657
```
