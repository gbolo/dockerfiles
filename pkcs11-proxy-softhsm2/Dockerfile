FROM    gbolo/baseos:debian

# CONFIGURABLE DEFAULTS
ARG     PKCS11_PROXY_PORT=5657

ENV     PKCS11_DAEMON_SOCKET=tcp://0.0.0.0:${PKCS11_PROXY_PORT}

# INSTALL PKCS11-PROXY AND SOFTHSM2
RUN     set -xe; \
# install basics that we need
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y --no-install-recommends softhsm2 git build-essential cmake libssl-dev libseccomp-dev && \
        mkdir -p /var/lib/softhsm/tokens && \
        rm -rf /var/lib/apt/lists/* && \
        git clone https://github.com/SUNET/pkcs11-proxy /tmp/pkcs11-proxy && \
        cd /tmp/pkcs11-proxy && cmake . && make && make install && \
        rm -rf /tmp/pkcs11-proxy

EXPOSE  ${PKCS11_PROXY_PORT}

CMD [ "/usr/local/bin/pkcs11-daemon", "/usr/lib/softhsm/libsofthsm2.so" ]
