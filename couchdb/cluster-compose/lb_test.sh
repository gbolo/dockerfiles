#!/usr/bin/env bash
ADMIN_USER=admin
ADMIN_PASSWORD=password

if [ "${1}" == "nginx" ]; then
  echo "TARGET: nginx loadbalancer"
  LB_ADDRESS=127.0.0.1:55984
else
  echo "TARGET: HAproxy loadbalancer"
  LB_ADDRESS=127.0.0.1:5984
fi

echo "create database:"
curl -X PUT http://${ADMIN_USER}:${ADMIN_PASSWORD}@${LB_ADDRESS}/color2

echo "add two documents to different nodes:"
curl -X PUT http://${LB_ADDRESS}/color2/111 -d '{"name":"red"}'
curl -X PUT http://${LB_ADDRESS}/color2/112 -d '{"name":"blue"}'

echo "query differnet nodes for them:"
curl http://${LB_ADDRESS}/color2/111
curl http://${LB_ADDRESS}/color2/112

echo "shutdown node 1:"
docker stop cluster-compose_cdb1_1
sleep 5

echo "add two more docs to remaining nodes:"
curl -X PUT http://${LB_ADDRESS}/color2/113 -d '{"name":"green"}'
curl -X PUT http://${LB_ADDRESS}/color2/114 -d '{"name":"yellow"}'

echo "start up node 1:"
docker start cluster-compose_cdb1_1
sleep 5

echo "query node 1 for the latest two docs:"
curl http://${LB_ADDRESS}/color2/113
curl http://${LB_ADDRESS}/color2/114

echo "shutdown node 2:"
docker stop cluster-compose_cdb2_1
sleep 5

echo "add two more docs to remaining nodes:"
curl -X PUT http://${LB_ADDRESS}/color2/115 -d '{"name":"purple"}'
curl -X PUT http://${LB_ADDRESS}/color2/116 -d '{"name":"pink"}'

echo "start up node 2:"
docker start cluster-compose_cdb2_1
sleep 5

echo "query node 2 for the latest two docs:"
curl http://${LB_ADDRESS}/color2/115
curl http://${LB_ADDRESS}/color2/116
