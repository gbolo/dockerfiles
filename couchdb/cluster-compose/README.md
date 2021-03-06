# CouchDB 2.x Cluster Setup
This will create a couchdb cluster with an HAproxy fronting it.

## Requirements
- docker 17.12.0+
- docker-compose 1.18.0+

## Instructions
```
# clone this repo
git clone https://github.com/gbolo/dockerfiles
cd dockerfiles/couchdb/cluster-compose

# spin up the docker containers
docker-compose up -d

# tail the admin node logs to ensure that cluster is ready
docker logs -f cluster-compose_cdbadmin_1
...
Finishing Cluster Setup...
{"ok":true}
{"state":"cluster_finished"}
Cluster Membership on: couchdb1.demo.vme
{"all_nodes":["couchdb@couchdb1.demo.vme","couchdb@couchdb2.demo.vme","couchdb@couchdb3.demo.vme"],"cluster_nodes":["couchdb@couchdb1.demo.vme","couchdb@couchdb2.demo.vme","couchdb@couchdb3.demo.vme"]}
Cluster Membership on: couchdb2.demo.vme
{"all_nodes":["couchdb@couchdb1.demo.vme","couchdb@couchdb2.demo.vme","couchdb@couchdb3.demo.vme"],"cluster_nodes":["couchdb@couchdb1.demo.vme","couchdb@couchdb2.demo.vme","couchdb@couchdb3.demo.vme"]}
Cluster Membership on: couchdb3.demo.vme
{"all_nodes":["couchdb@couchdb1.demo.vme","couchdb@couchdb2.demo.vme","couchdb@couchdb3.demo.vme"],"cluster_nodes":["couchdb@couchdb1.demo.vme","couchdb@couchdb2.demo.vme","couchdb@couchdb3.demo.vme"]}

# test the cluster
./cluster_test.sh

# test the load balancer
./lb_test.sh

# clean up after your done...
docker-compose down -v
```
