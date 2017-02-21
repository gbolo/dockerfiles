FROM gbolo/c7-sensu
MAINTAINER George Bolo <gbolo@linuxctl.com>

# -----------------------------------------------------------------------------
# User should provide own configs or this container will not work.
# -----------------------------------------------------------------------------
COPY server.json /etc/sensu/conf.d/server.json

# -----------------------------------------------------------------------------
# run sensu
# -----------------------------------------------------------------------------
CMD ["/opt/sensu/bin/sensu-server","-d","/etc/sensu/conf.d"]


