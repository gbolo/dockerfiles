# Wireguard-Proxy Docker Image: [gbolo/wireguard-proxy:latest](https://hub.docker.com/r/gbolo/wireguard-proxy/)

## Purpose

Contains `wireguard` client and `proxy` server (both `SOCKS` and `HTTP` on the **same port**) so that you don't need to mess with your host DNS and routing tables ;)

## Usage
This container expects ALL wireguard interface configs to be mounted in `/etc/wireguard` with extension `*.conf`. Note that *ALL* configs placed in this directory will be started! Once wireguard interfaces are up the proxy will then start and listen on port `33080`. This port can handle both `SOCKS` and `HTTP` proxy protocols.

This container **MUST** be started with `NET_ADMIN` capabilities:

```
docker run -d --restart unless-stopped \
  --name wireguard-proxy \
  --cap-add=NET_ADMIN \
  --publish 127.0.0.1:33080:33080 \
  --volume "/etc/wireguard:/etc/wireguard/:ro" \
  gbolo/wireguard-proxy:latest
```

With the container started, you are now free to configure your browser's proxy extension (like foxyproxy) to point to `127.0.0.1:33080`. You may also use the above endpoint as tunnel for ssh connections. For example:

```
Host jump.protected.private
  # this node gets rebuilt when asg changes
  StrictHostKeyChecking no
  # use a SOCKS5 proxy to connect to this box ;)
  ProxyCommand /usr/bin/nc -x 127.0.0.1:33080 %h %p
```