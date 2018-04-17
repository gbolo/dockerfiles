FROM    gbolo/baseos:debian

# CONFIGURABLE DEFAULTS
ARG     PKCS11_PROXY_PORT=5657
ARG     SOFTHSM_GIT_REF=2.4.0

ENV     PKCS11_DAEMON_SOCKET=tcp://0.0.0.0:${PKCS11_PROXY_PORT} \
        PKCS11_SLOT_LABELS=someLabel1,slotLabel2 \
        PKCS11_SLOT_PIN=somePin \
        PKCS11_SO_PIN=1234

COPY    CKM_GENERIC_SECRET_KEY_GEN.patch /tmp/CKM_GENERIC_SECRET_KEY_GEN.patch

# INSTALL PKCS11-PROXY AND SOFTHSM2 FROM SOURCE
RUN     set -xe; \
        buildDeps=' \
          git \
          build-essential \
          cmake \
          libssl-dev \
          libseccomp-dev \
          libsqlite3-dev \
          autoconf \
          automake \
          libtool \
        '; \
        permDeps=' \
          sqlite3 \
          libssl1.1 \
          libseccomp2 \
        '; \
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y --no-install-recommends $buildDeps $permDeps && \
        rm -rf /var/lib/apt/lists/* && \
        git clone https://github.com/SUNET/pkcs11-proxy /tmp/pkcs11-proxy && \
        cd /tmp/pkcs11-proxy && cmake . && make && make install && \
        cd /; rm -rf /tmp/pkcs11-proxy && \
        git clone https://github.com/opendnssec/SoftHSMv2 /tmp/softhsm2 && \
        cd /tmp/softhsm2; git checkout ${SOFTHSM_GIT_REF} && \
        patch --batch -p1 < /tmp/CKM_GENERIC_SECRET_KEY_GEN.patch && \
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
