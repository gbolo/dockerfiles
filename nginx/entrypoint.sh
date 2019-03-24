#!/bin/sh

#
#  NGINX DEFAULT ENTRYPOINT
#    for use with image: gbolo/nginx
#

# execute entrypoint-base ------------------------------------------------------
/entrypoints/entrypoint-base

# print nginx image info -------------------------------------------------------
echo "> Executed entrypoint-nginx on: $(date)"
echo "> Nginx environment variables:"
env | grep NGINX_

# CONFD ------------------------------------------------------------------------
echo "> Invoking confd to generate default nginx.conf ..."
/usr/local/bin/confd -version
/usr/local/bin/confd -confdir /etc/confd.nginx -onetime -backend env

# NGINX ------------------------------------------------------------------------
if [ -z "$(ls -A /etc/nginx/conf.d)" ]; then
   echo "> !! WARNING !! no http servers defined in /etc/nginx/conf.d"
fi

# default
if [ $# -eq 0 ]; then
  # if inotify is enabled
  if [ "${NGINX_INOTIFY_FILES}" != "" ]; then
    echo "> Starting nginx (inotify enabled)..."
    /usr/sbin/nginx -g "daemon off;" &
    inotifywait -e modify,move,create,delete -mr --timefmt '%d/%m/%y %H:%M:%S' --format '%w%f (%e) @ %T' ${NGINX_INOTIFY_FILES} | \
      while read -r event; do
        echo ">> [INOTIFY] Reloading nginx: ${event}"
        nginx -s reload
      done
  else
    echo "> Starting nginx ..."
    /usr/sbin/nginx -g "daemon off;"
  fi

# custom command
else
  echo "> Executing as uid [$(/usr/bin/id -u)]: ${@}"
  exec "$@"
fi
