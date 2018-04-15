FROM    gbolo/baseos:debian

# CONFIGURABLE DEFAULTS
ARG     PKCS11_PROXY_PORT=5657
ARG     SOFTHSM_GIT_REF=2.4.0

ENV     PKCS11_DAEMON_SOCKET=tcp://0.0.0.0:${PKCS11_PROXY_PORT} \
        PKCS11_SLOT_LABEL=someLabel \
        PKCS11_SLOT_PIN=somePin \
        PKCS11_SO_PIN=1234

COPY    GENERATE_GENERIC_SECRET.patch /tmp/GENERATE_GENERIC_SECRET.patch

# INSTALL PKCS11-PROXY AND SOFTHSM2 FROM SOURCE
RUN     set -xe; \
        buildDeps=' \
          git \
          build-essential \
          cmake \
          libssl-dev \
          libseccomp-dev \
          libsqlite3-dev \
          libssl-dev \
          autoconf \
          automake \
          libtool \
        '; \
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y --no-install-recommends sqlite3 $buildDeps && \
        rm -rf /var/lib/apt/lists/* && \
        git clone https://github.com/SUNET/pkcs11-proxy /tmp/pkcs11-proxy && \
        cd /tmp/pkcs11-proxy && cmake . && make && make install && \
        cd /; rm -rf /tmp/pkcs11-proxy && \
        git clone https://github.com/opendnssec/SoftHSMv2 /tmp/softhsm2 && \
        cd /tmp/softhsm2; git checkout ${SOFTHSM_GIT_REF} && \
        patch -p1 < /tmp/GENERATE_GENERIC_SECRET.patch && \
        sh autogen.sh && \
        ./configure --disable-gost --with-objectstore-backend-db && \
        make && make install && cd /; rm -rf /tmp/softhsm2 && \
        mkdir -p /var/lib/softhsm/tokens && \
        sed -i "/^objectstore.backend/c\objectstore.backend = db" /etc/softhsm2.conf && \
        apt-get purge -y --auto-remove $buildDeps

COPY    entrypoint.sh /entrypoints/entrypoint-pkcs11-proxy

EXPOSE  ${PKCS11_PROXY_PORT}

ENTRYPOINT  ["/usr/bin/dumb-init", "--", "/entrypoints/entrypoint-pkcs11-proxy"]
CMD [ "/usr/local/bin/pkcs11-daemon", "/usr/local/lib/softhsm/libsofthsm2.so" ]
