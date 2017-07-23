#!/bin/bash

BROADCAST_MSG() {
  local MESSAGE=$1

  echo
  echo "======================================================================="
  echo "   > ${MESSAGE}"
  echo "======================================================================="
  echo
}

BROADCAST_MSG "Runng Fabric SoftHSM Test with NO premade crypto config"
sleep 2

BROADCAST_MSG "Downloading Required Docker Images"
for i in ca peer orderer; do
  docker pull gbolo/fabric-${i}:1.0.0-softhsm
done
docker pull gbolo/fabric-tools:1.0.0

BROADCAST_MSG "CLEANING UP PREVIOUS COMPOSE"
docker-compose down -v

BROADCAST_MSG "STARTING UP COMPOSE"
docker-compose up -d

BROADCAST_MSG "Tailing fabric-tools..."
docker logs fabric-tools -f

BROADCAST_MSG "CLEANING UP"
docker-compose down -v
docker rm dev-peer0.fabric.linuxctl.com-mycc-1.0
docker rm dev-peer1.fabric.linuxctl.com-mycc-1.0
docker rmi dev-peer0.fabric.linuxctl.com-mycc-1.0
docker rmi dev-peer1.fabric.linuxctl.com-mycc-1.0

BROADCAST_MSG "run 'docker-compose up' if you want to run again with all logs"
