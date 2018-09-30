#!/bin/sh

#
# made for testing this setup: https://github.com/gbolo/dockerfiles/blob/master/couchdb/cluster-compose/docker-compose.yml
# USE AT YOUR OWN RISK!
#

# parameters are:
#  1 - couchdb admin username
#  2 - couchdb admin password
#  3 - space seperated list of couchdb hostnames
if [ "$#" -ne 3 ]; then
    echo "ERROR: expecting 3 parameters... exiting"
    exit 1
fi

function setup {
  apk add --no-cache curl
  sleep 10
}

function genJsonClusterSetup {
  cat > /tmp/body.json << EOL
  {
    "action": "enable_cluster",
    "bind_address": "0.0.0.0",
    "username": "${ADMIN_USER}",
    "password": "${ADMIN_PASSWORD}",
    "node_count": "3"
  }
EOL
}

function genJsonRemoteEnableCluster {
  cat > /tmp/body.json << EOL
  {
    "action": "enable_cluster",
    "bind_address": "0.0.0.0",
    "username": "${ADMIN_USER}",
    "password": "${ADMIN_PASSWORD}",
    "port": 5984,
    "node_count": "3",
    "remote_node": "${1}",
    "remote_current_user": "${ADMIN_USER}",
    "remote_current_password": "${ADMIN_PASSWORD}"
  }
EOL
}

function genJsonRemoteAddNode {
  cat > /tmp/body.json << EOL
  {
  "action": "add_node",
  "host": "${1}",
  "port": 5984,
  "username": "${ADMIN_USER}",
  "password": "${ADMIN_PASSWORD}"
  }
EOL
}

# ------------------------------------------------------------------------------
setup

ADMIN_USER=${1}
ADMIN_PASSWORD=${2}
COUCHDB_NODES=${3}

NODE_COUNT=$(echo "${COUCHDB_NODES}" | wc -w)
INITIATOR_NODE=$(echo "${COUCHDB_NODES}" | cut -d' ' -f1)
REMAINING_NODES=$(echo "${COUCHDB_NODES}" | cut -d' ' -f2-)

echo "NODE_COUNT: ${NODE_COUNT}"
echo "INITIATOR_NODE: ${INITIATOR_NODE}"
echo "REMAINING_NODES: ${REMAINING_NODES}"
echo "---"
echo

for node in ${COUCHDB_NODES}; do
  echo "Enable Cluster on: ${node}"
  genJsonClusterSetup
  curl -s -X POST -H "Content-Type: application/json" http://${ADMIN_USER}:${ADMIN_PASSWORD}@${node}:5984/_cluster_setup -d @/tmp/body.json
done

for node in ${REMAINING_NODES}; do
  echo "Enable Remote Cluster: ${node}"
  genJsonRemoteEnableCluster ${node}
  curl -s -X POST -H "Content-Type: application/json" http://${ADMIN_USER}:${ADMIN_PASSWORD}@${INITIATOR_NODE}:5984/_cluster_setup -d @/tmp/body.json
  echo "Add Node: ${node}"
  genJsonRemoteAddNode ${node}
  curl -s -X POST -H "Content-Type: application/json" http://${ADMIN_USER}:${ADMIN_PASSWORD}@${INITIATOR_NODE}:5984/_cluster_setup -d @/tmp/body.json
done

echo "Finishing Cluster Setup..."
curl -s -X POST -H "Content-Type: application/json" http://${ADMIN_USER}:${ADMIN_PASSWORD}@${INITIATOR_NODE}:5984/_cluster_setup -d '{"action": "finish_cluster"}'
curl -s http://${ADMIN_USER}:${ADMIN_PASSWORD}@${INITIATOR_NODE}:5984/_cluster_setup

sleep 3
for node in ${COUCHDB_NODES}; do
  echo "Cluster Membership on: ${node}"
  curl -s http://${ADMIN_USER}:${ADMIN_PASSWORD}@${node}:5984/_membership
done
