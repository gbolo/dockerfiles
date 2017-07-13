#!/bin/sh
## bash is not installed, dont do any bashy stuff...
set -xe;

BUILD_DIR=/tmp/install
DATA_DIR=/data

cd ${BUILD_DIR}

# Download lego and do checksum
LEGO_FILENAME="lego_linux_amd64.tar.xz"
apk add --no-cache openssl
wget https://github.com/xenolf/lego/releases/download/v${LEGO_VERSION}/${LEGO_FILENAME}
echo "${LEGO_SHA1}  ${LEGO_FILENAME}" > checksum.txt
sha1sum -c checksum.txt
if [ $? -ne 0 ]; then
  echo "${LEGO_FILENAME} does not hash to ${LEGO_SHA1}"
  exit 1
fi
apk del openssl

# install lego
tar -xvf ${LEGO_FILENAME} lego_linux_amd64 -C /usr/local/bin/
mv /usr/local/bin/lego_linux_amd64 /usr/local/bin/lego
chmod 555 /usr/local/bin/lego

# copy over entrypoint
cp entrypoint.sh /entrypoint.sh
chmod 555 /entrypoint.sh
