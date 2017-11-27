#!/bin/sh

#
#  BASEOS DEFAULT ENTRYPOINT
#    for use with image: gbolo/baseos:alpine
#

# print baseos image info ------------------------------------------------------
echo "> Executed entrypoint-base on: $(date)"
echo "> Version Information:"
env | grep BASEOS_BUILD

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
