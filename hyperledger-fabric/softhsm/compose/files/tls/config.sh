#!/usr/bin/env bash

# SERVERS[CN]=HOSTNAMES
declare -A SERVERS=(
  [wild_fabric.linuxctl.com]="*.fabric.linuxctl.com"
)

# CLIENTS[CN]=HOSTNAMES
declare -A CLIENTS=(
  [generic-client]="generic-client"
)
