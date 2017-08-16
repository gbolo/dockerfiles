#!/bin/bash

# import variables
source .env

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
if [ "${1:-pull}" != "nopull" ]; then
  for i in ca peer orderer; do
    docker pull gbolo/fabric-${i}:${FABRIC_VERSION}-softhsm
  done
  docker pull gbolo/fabric-tools:${FABRIC_VERSION}
else
  echo "Skipping Pull..."
fi

BROADCAST_MSG "CLEANING UP PREVIOUS COMPOSE"
docker-compose down -v
docker rm $(docker ps -a --filter name="dev-peer[0-9].fabric.linuxctl.com-*" --format '{{.ID}}')
docker rmi $(docker images "dev-peer[0-9].fabric.linuxctl.com-*" --format '{{.ID}}')

BROADCAST_MSG "STARTING UP COMPOSE"
docker-compose up -d

BROADCAST_MSG "Tailing fabric-tools..."
docker logs fabric-tools -f

BROADCAST_MSG "CLEANING UP"
if [ "${2:-clean}" != "noclean" ]; then
  docker-compose down -v
  docker rm $(ps -a --filter name="dev-peer[0-9].fabric.linuxctl.com-*" --format '{{.ID}}')
  docker rmi $(docker images "dev-peer[0-9].fabric.linuxctl.com-*" --format '{{.ID}}')
else
  echo "Skipping Cleanup..."
fi


BROADCAST_MSG "run 'docker-compose up' if you want to run again with all logs"
