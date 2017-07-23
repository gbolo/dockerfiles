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
    --url https://${FABRIC_CA_FQDN}:7054

  sleep 0.25
}

echo ">>>> ENROLLING ADMIN <<<<"
fabric-ca-client enroll --url https://gbolo:testing@${FABRIC_CA_FQDN}:7054
cp -rp /etc/hyperledger/fabric-ca-server/msp/signcerts /etc/hyperledger/fabric-ca-server/msp/admincerts

REGISTER_USER testclient client
REGISTER_USER peer0 peer
REGISTER_USER peer1 peer
REGISTER_USER peer2 peer
REGISTER_USER peer3 peer
REGISTER_USER orderer0 orderer
