#!/bin/sh

#
#  NGINX DEFAULT ENTRYPOINT
#    for use with image: gbolo/nginx
#

# CONFD ------------------------------------------------------------------------
echo "Invoking confd to generate default nginx.conf ..."
/usr/local/bin/confd -version
/usr/local/bin/confd -confdir /etc/confd.nginx -onetime -backend env

if [ -d /etc/confd ]; then
  echo "Invoking confd to generate additional config files(s) ..."
  /usr/local/bin/confd -onetime -backend env
fi

# NGINX ------------------------------------------------------------------------
if [ -z "$(ls -A /etc/nginx/conf.d)" ]; then
   echo "WARNING: no default servers defined in /etc/nginx/conf.d"
fi

if [ $# -eq 0 ]; then
  echo "Starting nginx ..."
  /usr/sbin/nginx -g "daemon off;"
else
  echo "Executing: ${@}"
  exec "$@"
fi
