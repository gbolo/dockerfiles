#!/bin/sh

#
# made for testing this setup: https://github.com/gbolo/dockerfiles/blob/master/couchdb/cluster-compose/docker-compose.yml
# USE AT YOUR OWN RISK!
#

# parameters are:
#  1 - couchdb admin username
#  2 - couchdb admin password
#  3 - space seperated list of couchdb hostnames
if [ "$#" -lt 4 ]; then
    echo "ERROR: expecting 4 or more parameters... exiting"
    exit 1
fi

# if no port is provided, use this default port:
DEFAULT_PORT=5984

# ------------------------------------------------------------------------------
function setup {

  if ! [ -x "$(command -v curl)" ]; then
    apk add --no-cache curl
  fi
  
  # wait a bit in case your laptop is slow...
  sleep 5
}

function genJsonClusterSetup {
  cat > /tmp/body.json << EOL
  {
    "action": "enable_cluster",
    "bind_address": "0.0.0.0",
    "username": "${ADMIN_USER}",
    "password": "${ADMIN_PASSWORD}",
    "node_count": "${NODE_COUNT}"
  }
EOL
}

function genJsonRemoteEnableCluster {
  host=$(echo "${1}" | cut -d ":" -f1)
  port=$(echo "${1}" | cut -d ":" -f2 -s)

  cat > /tmp/body.json << EOL
  {
    "action": "enable_cluster",
    "bind_address": "0.0.0.0",
    "username": "${ADMIN_USER}",
    "password": "${ADMIN_PASSWORD}",
    "port": ${port:-$DEFAULT_PORT},
    "node_count": "${NODE_COUNT}",
    "remote_node": "${host}",
    "remote_current_user": "${ADMIN_USER}",
    "remote_current_password": "${ADMIN_PASSWORD}"
  }
EOL
}

function genJsonRemoteAddNode {
  host=$(echo "${1}" | cut -d ":" -f1)
  port=$(echo "${1}" | cut -d ":" -f2 -s)

  cat > /tmp/body.json << EOL
  {
  "action": "add_node",
  "host": "${host}",
  "port": ${port:-$DEFAULT_PORT},
  "username": "${ADMIN_USER}",
  "password": "${ADMIN_PASSWORD}"
  }
EOL
}

function validateResponseCode {
  response_code=${1}
  matches=0

  # since /bin/sh doesn't support "${@:2}"
  # we need to use `shift` to support /bin/sh
  shift

  for valid_code in ${@}; do
    if [ "${response_code}" = "${valid_code}" ]; then
      matches=$((matches+1))
    fi
  done

  if [ "${matches}" -eq 0 ]; then
    echo "bad response code [${response_code}]. Exiting"
    echo "response body:"
    cat /tmp/response
    exit 1
  fi

  echo "response code [${response_code}] is OK"
}

function getNodeAddress {
  port=$(echo "${1}" | cut -d ":" -f2 -s)
  if [ -z "${port}" ]; then
    echo "${1}:${DEFAULT_PORT}"
  else
    echo "${1}"
  fi
}

# ------------------------------------------------------------------------------
setup

ADMIN_USER=${1}
ADMIN_PASSWORD=${2}
# since /bin/sh doesn't support "${@:3}"
# we need to use `shift` to support /bin/sh
shift; shift
COUCHDB_NODES="${@}"

NODE_COUNT=$(echo "${COUCHDB_NODES}" | wc -w)
INITIATOR_NODE=$(echo "${COUCHDB_NODES}" | cut -d' ' -f1)
REMAINING_NODES=$(echo "${COUCHDB_NODES}" | cut -d' ' -f2-)

echo "NODE_COUNT: ${NODE_COUNT}"
echo "INITIATOR_NODE: ${INITIATOR_NODE}"
echo "REMAINING_NODES: ${REMAINING_NODES}"
echo "---"
echo

for node in ${COUCHDB_NODES}; do
  target_node=$(getNodeAddress ${node})
  echo "Enable Cluster on: ${node} [target: ${target_node}]"
  genJsonClusterSetup
  code=$(curl --write-out %{http_code} --output /tmp/response -s -X POST -H "Content-Type: application/json" http://${ADMIN_USER}:${ADMIN_PASSWORD}@${target_node}/_cluster_setup -d @/tmp/body.json)
  validateResponseCode ${code} 200 400
done

for node in ${REMAINING_NODES}; do
  target_node=$(getNodeAddress ${INITIATOR_NODE})
  echo "Enable Remote Cluster: ${node} [target: ${target_node}]"
  genJsonRemoteEnableCluster ${node}
  code=$(curl --write-out %{http_code} --output /tmp/response -s -X POST -H "Content-Type: application/json" http://${ADMIN_USER}:${ADMIN_PASSWORD}@${target_node}/_cluster_setup -d @/tmp/body.json)
  validateResponseCode ${code} 201
  echo "Add Node: ${node} [target: ${target_node}]"
  genJsonRemoteAddNode ${node}
  code=$(curl --write-out %{http_code} --output /tmp/response -s -X POST -H "Content-Type: application/json" http://${ADMIN_USER}:${ADMIN_PASSWORD}@${target_node}/_cluster_setup -d @/tmp/body.json)
  validateResponseCode ${code} 201
done

target_node=$(getNodeAddress ${INITIATOR_NODE})
echo "Finishing Cluster Setup... [target: ${target_node}]"
code=$(curl --write-out %{http_code} --output /tmp/response -s -X POST -H "Content-Type: application/json" http://${ADMIN_USER}:${ADMIN_PASSWORD}@${target_node}/_cluster_setup -d '{"action": "finish_cluster"}')
validateResponseCode ${code} 201
code=$(curl --write-out %{http_code} --output /tmp/response -s http://${ADMIN_USER}:${ADMIN_PASSWORD}@${target_node}/_cluster_setup)
validateResponseCode ${code} 200 201

sleep 3
for node in ${COUCHDB_NODES}; do
  target_node=$(getNodeAddress ${node})
  echo "Cluster Membership on: ${node} [target: ${target_node}]"
  code=$(curl --write-out %{http_code} --output /tmp/response -s http://${ADMIN_USER}:${ADMIN_PASSWORD}@${target_node}/_membership)
  validateResponseCode ${code} 200
  cat /tmp/response
done

echo "SUCCESS!"
exit 0
