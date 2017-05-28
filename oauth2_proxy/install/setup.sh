#!/bin/sh
## bash is not installed, dont do any bashy stuff...
set -xe;

BUILD_DIR=/tmp/install
DATA_DIR=/data

cd ${BUILD_DIR}

# Download oauth2_proxy and do checksum
OAUTH2_FILENAME="oauth2_proxy-${OAUTH2_PROXY_VERSION}.0.linux-amd64.go1.8.1.tar.gz"
apk add --no-cache openssl
wget https://github.com/bitly/oauth2_proxy/releases/download/v${OAUTH2_PROXY_VERSION}/${OAUTH2_FILENAME}
echo "${OAUTH2_PROXY_SHA1}  ${OAUTH2_FILENAME}" > checksum.txt
sha1sum -c checksum.txt
if [ $? -ne 0 ]; then
  echo "${OAUTH2_FILENAME} does not hash to ${OAUTH2_PROXY_SHA1}"
  exit 1
fi
apk del openssl

# install oauth2_proxy
tar -xzvf ${OAUTH2_FILENAME} --strip 1 -C /usr/local/bin/
chmod 555 /usr/local/bin/oauth2_proxy

# copy over entrypoint
cp entrypoint.sh /entrypoint.sh
chmod 555 /entrypoint.sh
