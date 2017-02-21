FROM gbolo/c7-sensu
MAINTAINER George Bolo <gbolo@linuxctl.com>

# -----------------------------------------------------------------------------
# User should provide own configs or this container will not work.
# -----------------------------------------------------------------------------
COPY api.json /etc/sensu/conf.d/api.json

# -----------------------------------------------------------------------------
# run sensu
# -----------------------------------------------------------------------------
CMD ["/opt/sensu/bin/sensu-api","-d","/etc/sensu/conf.d"]

EXPOSE 4567
