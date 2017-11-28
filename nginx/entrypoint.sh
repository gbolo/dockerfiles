#!/bin/sh

#
#  NGINX DEFAULT ENTRYPOINT
#    for use with image: gbolo/nginx
#

# execute entrypoint-base ------------------------------------------------------
/entrypoints/entrypoint-base

# print nginx image info -------------------------------------------------------
echo "> Executed entrypoint-nginx on: $(date)"
echo "> Nginx envioronment variables:"
env | grep NGINX_

# CONFD ------------------------------------------------------------------------
echo "> Invoking confd to generate default nginx.conf ..."
/usr/local/bin/confd -version
/usr/local/bin/confd -confdir /etc/confd.nginx -onetime -backend env

# NGINX ------------------------------------------------------------------------
if [ -z "$(ls -A /etc/nginx/conf.d)" ]; then
   echo "> !! WARNING !! no http servers defined in /etc/nginx/conf.d"
fi

if [ $# -eq 0 ]; then
  echo "> Starting nginx ..."
  /usr/sbin/nginx -g "daemon off;"
else
  echo "> Executing as uid [$(/usr/bin/id -u)]: ${@}"
  exec "$@"
fi
