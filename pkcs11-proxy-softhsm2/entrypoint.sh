#!/bin/sh

#
#  PKCS11-PROXY DEFAULT ENTRYPOINT
#    for use with image: gbolo/hsm-pkcs11proxy
#

# execute entrypoint-base ------------------------------------------------------
/entrypoints/entrypoint-base

# print nginx image info -------------------------------------------------------
echo "> Executed entrypoint-pkcs11-proxy on: $(date)"
echo "> pkcs11-proxy environment variables:"
env | grep PKCS11_

# hsm-pkcs11proxy --------------------------------------------------------------
if ! $(softhsm2-util --show-slots | grep -ilq ".*Label.*${PKCS11_SLOT_LABEL}"); then
  echo "> Initializing softhsm2 slot: ${PKCS11_SLOT_LABEL}"
  softhsm2-util --init-token --free \
    --label ${PKCS11_SLOT_LABEL} \
    --pin ${PKCS11_SLOT_PIN} \
    --so-pin ${PKCS11_SO_PIN}
fi

echo "> Executing as uid [$(/usr/bin/id -u)]: ${@}"
exec "$@"
