#!/bin/sh

apk add --no-cache curl
sleep 10

USER_NAME=couchdb
PASSWORD=password

for i in `seq 1 3`; do
  curl -s -X POST -H "Content-Type: application/json" http://${USER_NAME}:${PASSWORD}@couchdb${i}.demo.vme:5984/_cluster_setup -d '{"action": "enable_cluster", "bind_address":"0.0.0.0", "username": "couchdb", "password":"password", "node_count":"3"}'
done


curl -s -X POST -H "Content-Type: application/json" http://${USER_NAME}:${PASSWORD}@couchdb1.demo.vme:5984/_cluster_setup -d '{"action": "enable_cluster", "bind_address":"0.0.0.0", "username": "couchdb", "password":"password", "port": 5984, "node_count": "3", "remote_node": "couchdb2.demo.vme", "remote_current_user": "couchdb", "remote_current_password": "password" }'

curl -s -X POST -H "Content-Type: application/json" http://${USER_NAME}:${PASSWORD}@couchdb1.demo.vme:5984/_cluster_setup -d '{"action": "add_node", "host":"couchdb2.demo.vme", "port": 5984, "username": "couchdb", "password":"password"}'

curl -s -X POST -H "Content-Type: application/json" http://${USER_NAME}:${PASSWORD}@couchdb1.demo.vme:5984/_cluster_setup -d '{"action": "enable_cluster", "bind_address":"0.0.0.0", "username": "couchdb", "password":"password", "port": 5984, "node_count": "3", "remote_node": "couchdb3.demo.vme", "remote_current_user": "couchdb", "remote_current_password": "password" }'

curl -s -X POST -H "Content-Type: application/json" http://${USER_NAME}:${PASSWORD}@couchdb1.demo.vme:5984/_cluster_setup -d '{"action": "add_node", "host":"couchdb3.demo.vme", "port": 5984, "username": "couchdb", "password":"password"}'



curl -s -X POST -H "Content-Type: application/json" http://${USER_NAME}:${PASSWORD}@couchdb1.demo.vme:5984/_cluster_setup -d '{"action": "finish_cluster"}'

curl -s http://${USER_NAME}:${PASSWORD}@couchdb1.demo.vme:5984/_cluster_setup


for i in `seq 1 3`; do
  curl -s http://${USER_NAME}:${PASSWORD}@couchdb${i}.demo.vme:5984/_membership
done
