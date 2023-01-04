FROM	alpine:3

ARG	gost_version=2.11.4

# install wireguard tools
RUN	set -xe; \
    apk add --no-cache --update \
      wireguard-tools openresolv iptables ip6tables curl

# install our proxy of choice for now (gost)
RUN	curl -sL -o /usr/bin/gost.gz https://github.com/ginuerzh/gost/releases/download/v${gost_version}/gost-linux-amd64-${gost_version}.gz && \
    gunzip /usr/bin/gost.gz && \
	  chmod +x /usr/bin/gost

# where all wireguard configs should be stored
VOLUME /etc/wireguard

COPY	./entrypoint.sh	/entrypoint.sh
ENTRYPOINT	["/entrypoint.sh"]
