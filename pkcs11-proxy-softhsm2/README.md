# Docker Image: [gbolo/hsm-pkcs11proxy:latest](https://hub.docker.com/r/gbolo/hsm-pkcs11proxy/)

[![Docker Automated build](https://img.shields.io/docker/automated/gbolo/hsm-pkcs11proxy.svg)]()
[![Docker Build Status](https://img.shields.io/docker/build/gbolo/hsm-pkcs11proxy.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/gbolo/hsm-pkcs11proxy.svg)]()

## Features

Light weight, Alpine based HSM pkcs11-proxy (softhsm2) docker image available at: [gbolo/hsm-pkcs11proxy:latest](https://hub.docker.com/r/gbolo/hsm-pkcs11proxy/)

### gbolo/baseos:debian base image
 - inherits all features found in [gbolo/baseos:debian](https://hub.docker.com/r/gbolo/baseos)

### Dynamic init of softhsm slot
 - dynamically creation of softhsm2 slot based on the following environment variables:
 ```
  PKCS11_SLOT_LABEL=someLabel
  PKCS11_SLOT_PIN=somePin
  PKCS11_SO_PIN=1234
 ```
