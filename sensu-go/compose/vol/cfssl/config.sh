#!/usr/bin/env bash

# SERVERS[CN]=HOSTNAMES
declare -A SERVERS=(
  [etcd]="etcd1.sensu.dev,etcd2.sensu.dev,etcd3.sensu.dev,localhost,127.0.0.1"
  [sensu-backend]="backend.sensu.dev,api.sensu.dev,localhost,127.0.0.1"
  [sensu-web]="web.sensu.dev,localhost,127.0.0.1"
)

# CLIENTS[CN]=HOSTNAMES
declare -A CLIENTS=(
  [sensu-agent]="sensu-agent"
  [etcd]="etcd-client"
)
