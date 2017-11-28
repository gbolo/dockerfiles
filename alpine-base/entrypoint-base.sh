#!/bin/sh

#
#  BASEOS DEFAULT ENTRYPOINT
#    for use with image: gbolo/baseos:[alpine/debian]
#
#  ** bash may not be installed, so don't do any bashy stuff...
#

# print baseos image info ------------------------------------------------------
echo "> Executed entrypoint-base on: $(date)"
echo "> Version Information:"
env | grep BASEOS_BUILD

# timezone configuration -------------------------------------------------------
if [ "$(cat /etc/timezone)" != "${TZ:-none}" ] && [ "none" != "${TZ:-none}" ]; then
  echo "> Timezone env [TZ] does not match /etc/timezone"
  if [ "$(id -u)" -eq 0 ]; then
    if [ -f /usr/share/zoneinfo/${TZ} ]; then
      echo "> Setting timezone to ${TZ}"
      ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime
      echo ${TZ} > /etc/timezone
    else
      echo "> !! WARNING !! TZ error, cannot find /usr/share/zoneinfo/${TZ}"
    fi
  else
    echo "> !! WARNING !! running as non-root, cannot fix timezone."
  fi
fi

# update-ca-certificates -------------------------------------------------------
# if running as root and there are ca certs defined, then lets load them
if [ "$(id -u)" -eq 0 ]; then
  if [ $(ls -1 /usr/local/share/ca-certificates/*.crt 2>/dev/null | wc -l) != 0 ]; then
    echo "> Updating system CA certificate(s)..."
    update-ca-certificates
  fi
fi

# confd ------------------------------------------------------------------------
# if /etc/confd exists, lets try and run confd
if [ -d /etc/confd ]; then
  echo "> Invoking confd to generate config files(s) ..."
  /usr/local/bin/confd --version
  /usr/local/bin/confd -onetime -backend env
fi

# exec when arguments exist or else exit ---------------------------------------
if [ $# -eq 0 ]; then
  echo "> Exiting entrypoint-base"
  echo
  exit 0
else
  echo "> Executing as uid [$(/usr/bin/id -u)]: ${@}"
  exec "$@"
fi
