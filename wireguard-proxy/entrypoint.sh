#!/bin/sh

#
#  WIREGUARD-PROXY DEFAULT ENTRYPOINT
#    for use with image: gbolo/wireguard-proxy
#

launch_all_wg_interfaces() {
    wg_interfaces=`find /etc/wireguard -type f -name "*.conf"`
    if [ -z $wg_interfaces ]; then
        echo "could not find any *.conf files in /etc/wireguard. Exiting..." >&2
        exit 1
    fi

    for interface in $wg_interfaces; do
        echo "[$(date)] wg-quick up $interface"
        wg-quick up $interface
    done
}

launch_proxy() {
    echo "[$(date)] starting socks+http proxy"
    /usr/bin/gost -L :33080
}

launch_all_wg_interfaces
launch_proxy