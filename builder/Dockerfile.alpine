# github.com/gbolo/dockerfiles/builder/Dockerfile.alpine

FROM  gbolo/baseos:alpine

# DEFAULTS
ENV     GOROOT=/usr/lib/go \
        GOPATH=/opt/gopath \
        PATH=${PATH}:/opt/gopath/bin

# SETUP DEV TOOLS
RUN     set -xe; \
# upgrade all packages
        apk upgrade --no-progress --no-cache && \
# install everything we may want (it's OK to repeat pkgs!)
        apk add --no-cache build-base alpine-sdk \
           git gcc libtool musl-dev file openssl-dev openssl \
           g++ make curl ca-certificates patch bash go \
           python2 python3 python2-dev python3-dev py2-pip \
           php5 php7 nodejs nodejs-npm nodejs-dev && \
        pip3 install --upgrade pip setuptools && \
        pip2 install --upgrade pip setuptools && \
# get gopath ready
        mkdir -p ${GOPATH}

ENTRYPOINT  ["/bin/bash"]
