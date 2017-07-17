FABRIC_CA_FQDN="${1:-localhost}"

REGISTER_USER() {
  local USER_ID=$1
  local USER_TYPE=$2
  local USER_AFF="${3:-org1}"

  fabric-ca-client register \
    --id.name ${USER_ID} \
    --id.secret testing \
    --id.type ${USER_TYPE} \
    --id.affiliation ${USER_AFF} \
    --url http://${FABRIC_CA_FQDN}:7054

  sleep 0.25
}


fabric-ca-client enroll --url http://gbolo:testing@${FABRIC_CA_FQDN}:7054

REGISTER_USER testclient client
REGISTER_USER peer0 peer
REGISTER_USER peer1 peer
REGISTER_USER peer2 peer
REGISTER_USER peer3 peer
REGISTER_USER orderer0 orderer
