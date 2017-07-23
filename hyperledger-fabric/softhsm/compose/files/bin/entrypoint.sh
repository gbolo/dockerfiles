#!/usr/bin/env bash
################################################################################
#
#   simple entrypoint script for hyperledger fabric
#   intended to be used for testing pkcs11 with gbolo/fabric-* docker images
#
################################################################################

BROADCAST_MSG() {
  local MESSAGE=$1

  echo
  echo "======================================================================="
  echo "   > ${MESSAGE}"
  echo "======================================================================="
  echo
}

ENROLL_CLIENT() {
  BROADCAST_MSG "ENROLLING CLIENT... ${FABRIC_CA_CLIENT_URL}"
  /usr/local/bin/fabric-ca-client enroll --url "${FABRIC_CA_CLIENT_URL}"

  BROADCAST_MSG "TEMP HACKS. COPY ADMINCERTS, TLSCERTS"

  if [[ -z "${ORDERER_GENERAL_LOCALMSPDIR}" ]]; then
    cp -rp /data/adminOrg1MSP/signcerts /etc/hyperledger/fabric/msp/admincerts
    echo "diff admin certs..."
    diff /data/adminOrg1MSP/signcerts/cert.pem /etc/hyperledger/fabric/msp/signcerts/cert.pem
  else
    cp -rp /data/adminOrdererOrg1MSP/signcerts ${ORDERER_GENERAL_LOCALMSPDIR}/admincerts
    echo "diff admin certs..."
    diff /data/adminOrdererOrg1MSP/signcerts/cert.pem ${ORDERER_GENERAL_LOCALMSPDIR}/signcerts/cert.pem
  fi

  echo
  echo "copying tlscacerts..."
  if [[ -z "${ORDERER_GENERAL_LOCALMSPDIR}" ]]; then
    mkdir -p /etc/hyperledger/fabric/msp/tlscacerts
    cp -rp /data/tls/ca_root.pem /etc/hyperledger/fabric/msp/tlscacerts/
  else
    mkdir -p ${ORDERER_GENERAL_LOCALMSPDIR}/tlscacerts
    cp -rp /data/tls/ca_root.pem ${ORDERER_GENERAL_LOCALMSPDIR}/tlscacerts/

    # tmp hack, get tlscacerts in geneisis
    cp -rp ${ORDERER_GENERAL_LOCALMSPDIR}/tlscacerts /data/adminOrg1MSP/
    cp -rp ${ORDERER_GENERAL_LOCALMSPDIR}/tlscacerts /data/adminOrdererOrg1MSP/
  fi

}

START_DAEMON() {
  BROADCAST_MSG "STARTING DAEMON... $@"
  exec "$@"
}


ENROLL_CLIENT

START_DAEMON "$@"
