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
}

START_DAEMON() {
  BROADCAST_MSG "STARTING DAEMON... $@"
  exec "$@"
}


ENROLL_CLIENT

# temp hack...
rm -rf ${FABRIC_CA_CLIENT_MSPDIR}/admincerts
cp -rp ${FABRIC_CA_CLIENT_MSPDIR}/signcerts ${FABRIC_CA_CLIENT_MSPDIR}/admincerts

START_DAEMON "$@"
