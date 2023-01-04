#!/bin/sh

#
#  WIREGUARD-PROXY DEFAULT ENTRYPOINT
#    for use with image: gbolo/wireguard-proxy
#

get_all_wg_interfaces() {
    wg_interfaces=`find /etc/wireguard -type f -name "*.conf"`
    if [ -z $wg_interfaces ]; then
        echo "could not find any *.conf files in /etc/wireguard. Exiting..." >&2
        exit 1
    fi
}

launch_all_wg_interfaces() {
    get_all_wg_interfaces
    for interface in $wg_interfaces; do
        echo "[$(date)] wg-quick up $interface"
        wg-quick up $interface
    done
}

terminate_all() {
    get_all_wg_interfaces
    for interface in $wg_interfaces; do
        echo "[$(date)] wg-quick down $interface"
        wg-quick down $interface
    done
    echo "[$(date)] killall gost"
    killall gost
}

launch_proxy() {
    echo "[$(date)] starting socks+http proxy (gost)"
    gost -L :33080 &
}

launch_all_wg_interfaces
launch_proxy

trap "terminate_all" SIGINT SIGTERM SIGQUIT
wait