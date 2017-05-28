#!/bin/sh
## bash is not installed, dont do any bashy stuff...
set -xe;

BUILD_DIR=/tmp/install
DATA_DIR=/data

cd ${BUILD_DIR}

# Download h5ai and do checksum
apk add --no-cache openssl
wget https://release.larsjung.de/h5ai/h5ai-${H5AI_VERSION}.zip
echo "${H5AI_SHA1}  h5ai-${H5AI_VERSION}.zip" > checksum.txt
sha1sum -c checksum.txt
if [ $? -ne 0 ]; then
  echo "h5ai-${H5AI_VERSION}.zip does not hash to ${H5AI_SHA1}"
  exit 1
fi
apk del openssl

# Install some software from apk
apk add --no-cache php7-fpm php7-session php7-json php7-gd php7-exif \
  unzip zip ffmpeg imagemagick

# copy over some config files
cp conf_php-fpm/*.conf /etc/php7/php-fpm.d/
chmod 444 /etc/php7/php-fpm.d/*.conf

# install h5ai
mkdir -p ${DATA_DIR}/h5ai
unzip h5ai-${H5AI_VERSION}.zip -d ${DATA_DIR}/h5ai
chown -R nobody:nobody ${DATA_DIR}/h5ai

# copy over entrypoint
cp entrypoint.sh /entrypoint.sh
chmod 555 /entrypoint.sh

# setup templates
mkdir -p /etc/confd/conf.d
mkdir -p /etc/confd/templates

cp confd_config/* /etc/confd/conf.d/
cp confd_templates/* /etc/confd/templates/
