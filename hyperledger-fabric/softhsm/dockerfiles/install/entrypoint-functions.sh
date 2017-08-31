#!/usr/bin/env bash
################################################################################
#
#   Entrypoint logic for Hyperledger Fabric based docker images
#   intended to be used for testing pkcs11 with gbolo/fabric-* docker images
#
#   FEATURES:
#    - No pre-made crypto-config required! (Production-like)
#    - Ability to Enroll itself Against a Fabric-CA server
#    - Fully working pkcs11 implementation with test case before starting daemon
#    - Ability to copy in TLSCA certs and Admin certs from ENV vars
#    - Ability to run extended entrypoint script specified in ENV var
#
#   ENV VARS REQUIRED TO RUN THIS ENTRYPOINT:
#    FABRIC_CA_CLIENT_BCCSP_*  - bccsp configuration for fabric client to enroll
#    FABRIC_CA_CLIENT_URL      - url with basicauth to fabric-ca-server to enroll
#    MSP_ADMIN_DIR             - path to directory containing admin certs
#    DAEMON_TYPE               - type of deamon running: peer,orderer,ca
#
#   ENV VARS THAT ARE OPTIONAL:
#    MSP_TLSCACERTS_DIR        - path to directory containing tls ca certs
#    ENTRYPOINT_EXTENDED       - path to script we should run for extra setup
#
################################################################################

#
# FUNCTIONS
#

BROADCAST_MSG() {
  local MESSAGE=$1

  echo
  echo "======================================================================="
  echo "   > ${MESSAGE}"
  echo "======================================================================="
  echo
}

VERIFY_RESULT() {
	if [ $1 -ne 0 ] ; then
		echo "!!!!! ${2:-ERROR} !!!!!"
		BROADCAST_MSG "EXITING DUE TO ERROR..."
		echo
		exit 1
	fi
}

TEST_PKCS11() {
  BROADCAST_MSG "TESTING PKCS11 LIBRARY"
  local TEST_OBJECT_LABEL="EC-TEST"
  # support both client and server
  local PKCS11_LIB=${FABRIC_CA_CLIENT_BCCSP_PKCS11_LIBRARY:-$FABRIC_CA_SERVER_BCCSP_PKCS11_LIBRARY}
  local PKCS11_PIN=${FABRIC_CA_CLIENT_BCCSP_PKCS11_PIN:-$FABRIC_CA_SERVER_BCCSP_PKCS11_PIN}
  local PKCS11_LABEL=${FABRIC_CA_CLIENT_BCCSP_PKCS11_LABEL:-$FABRIC_CA_SERVER_BCCSP_PKCS11_LABEL}

  # Create new ECDSA Keypair
  pkcs11-tool --module ${PKCS11_LIB} \
    --pin ${PKCS11_PIN} \
    --token-label ${PKCS11_LABEL} \
    --label ${TEST_OBJECT_LABEL} --id 0077 \
    --login --keypairgen --key-type EC:prime256v1

  VERIFY_RESULT $? "Failed to create EC keypair"

  # Test Signing
  echo
  echo "Test signing a file with test key"
  echo "TESTING" > /tmp/testcrypto.txt
  pkcs11-tool --module ${PKCS11_LIB} \
    --pin ${PKCS11_PIN} \
    --token-label ${PKCS11_LABEL} \
    --label ${TEST_OBJECT_LABEL} --id 0077 \
    --login --sign -m ECDSA \
    --input-file /tmp/testcrypto.txt \
    --output-file /tmp/testcrypto.txt.sig \
    --verbose

  VERIFY_RESULT $? "Failed to create signature"
  rm -rf /tmp/testcrypto.txt*

  # TODO: test signature verification, encryt, decrypt

  # Delete Test keypair
  echo
  echo "Deleting test keypair..."
  pkcs11-tool --module ${PKCS11_LIB} \
    --pin ${PKCS11_PIN} \
    --token-label ${PKCS11_LABEL} \
    --label ${TEST_OBJECT_LABEL} --id 0077 \
    --login --delete-object --type privkey

  pkcs11-tool --module ${PKCS11_LIB} \
    --pin ${PKCS11_PIN} \
    --token-label ${PKCS11_LABEL} \
    --label ${TEST_OBJECT_LABEL} --id 0077 \
    --login --delete-object --type pubkey
}

CHECK_FOR_EXISTING_PKCS11_FABRIC_KEY() {
  BROADCAST_MSG "CHECKING FOR EXISTING PKCS11 FABRIC KEY(S)"
  local FABRIC_PRIVKEY_LABEL="BCPRV1"
  local PKCS11_OBJECTS=$(pkcs11-tool --module ${FABRIC_CA_CLIENT_BCCSP_PKCS11_LIBRARY} \
    --pin ${FABRIC_CA_CLIENT_BCCSP_PKCS11_PIN} \
    --token-label ${FABRIC_CA_CLIENT_BCCSP_PKCS11_LABEL} \
    --login --list-objects --type privkey)

  if [ $? -eq 0 ]; then
    local PKCS11_FABRIC_KEYS=$(echo "${PKCS11_OBJECTS}" | grep ${FABRIC_PRIVKEY_LABEL} | wc -l)

    if [ $PKCS11_FABRIC_KEYS -gt 0 ]; then
      echo "Found ${PKCS11_FABRIC_KEYS} existing Fabric key(s):"
      echo "${PKCS11_OBJECTS}"
      return $PKCS11_FABRIC_KEYS
    else
      echo "No existing fabric keys found."
      return 0
    fi

  fi
}

CHECK_FOR_EXISTING_FABRIC_KEY() {
  BROADCAST_MSG "CHECKING FOR EXISTING FABRIC LOCAL KEY"
  local MSP_PATH=$(GET_MSP_PATH)

  if ls ${MSP_PATH}/keystore/*_sk 1> /dev/null 2>&1; then
    echo "Found existing Fabric key:"
    ls -al ${MSP_PATH}/keystore/*_sk
    return 1
  else
    echo "No existing fabric keys found."
    return 0
  fi
}

CHECK_FOR_EXISTING_FABRIC_ECERT() {
  BROADCAST_MSG "CHECKING FOR EXISTING FABRIC ENROLLMENT CERT"
  local MSP_PATH=$(GET_MSP_PATH)

  if ls ${MSP_PATH}/signcerts/*.pem 1> /dev/null 2>&1; then
    echo "Found existing Fabric Enrollment Certificate:"
    ls -al ${MSP_PATH}/signcerts/*.pem
    return 1
  else
    echo "No existing fabric enrollment certificate found."
    return 0
  fi
}

ENROLL_CLIENT() {
  BROADCAST_MSG "ENROLLING CLIENT..."

  if [ ${FABRIC_CA_CLIENT_URL:-NOTSET} == "NOTSET" ]; then
    echo "Enrollment Error!"
    echo "ENV FABRIC_CA_CLIENT_URL IS NOT SET"
    exit 1
  fi

  /usr/local/bin/fabric-ca-client enroll --url "${FABRIC_CA_CLIENT_URL}"
  VERIFY_RESULT $? "Error enrolling client against ${FABRIC_CA_CLIENT_URL}"
}

GET_MSP_PATH() {
  local MSP_DEFAULT="/etc/hyperledger/fabric/msp"

  # TODO: extend the logic here at some point...
  if [ ${DAEMON_TYPE} == "peer" ]; then
    local MSP_PATH=${FABRIC_CA_CLIENT_MSPDIR:-$MSP_DEFAULT}
  elif [ ${DAEMON_TYPE} == "orderer" ]; then
    local MSP_PATH=${FABRIC_CA_CLIENT_MSPDIR:-$MSP_DEFAULT}
  else
    local MSP_PATH="NOTNEEDED"
  fi

  echo "${MSP_PATH}"
}

COPY_ADMIN_CERTS() {
  BROADCAST_MSG "COPYING ADMIN CERTS TO MSP"

  if [ ${MSP_ADMIN_DIR:-NOTSET} == "NOTSET" ]; then
    echo "MSP Error!"
    echo "ENV MSP_ADMIN_DIR IS NOT SET"
    exit 1
  fi

  local MSP_PATH=$(GET_MSP_PATH)
  if [ ${MSP_PATH} != "NOTNEEDED" ]; then
    echo "copy from ${MSP_ADMIN_DIR}/*.pem to ${MSP_PATH}/admincerts/"
    mkdir -p ${MSP_PATH}/admincerts
    cp -rp ${MSP_ADMIN_DIR}/*.pem ${MSP_PATH}/admincerts
  else
    echo "Skipping... only needed for peers and orderers"
  fi
}

COPY_TLSCA_CERTS() {
  BROADCAST_MSG "COPYING TLSCA CERTS TO MSP"

  if [ ${MSP_ADMIN_DIR:-NOTSET} == "NOTSET" ]; then
    echo "MSP Error!"
    echo "ENV MSP_ADMIN_DIR IS NOT SET"
    exit 1
  fi

  local MSP_PATH=$(GET_MSP_PATH)
  if [ ${MSP_PATH} != "NOTNEEDED" ]; then
    echo "copy from ${MSP_TLSCACERTS_DIR}/*.pem to ${MSP_PATH}/tlscacerts/"
    mkdir -p ${MSP_PATH}/tlscacerts
    cp -rp ${MSP_TLSCACERTS_DIR}/*.pem ${MSP_PATH}/tlscacerts/
  else
    echo "Skipping... only needed for peers and orderers"
  fi
}

EXECUTE_ADDITIONAL_SCRIPT() {
  local DEFAULT_EXTENDED_SCRIPT=/usr/local/bin/entrypoint-extended.sh

  if [ -f ${ENTRYPOINT_EXTENDED:-$DEFAULT_EXTENDED_SCRIPT} ]; then
    BROADCAST_MSG "Executing ${ENTRYPOINT_EXTENDED}"
    chmod +x ${ENTRYPOINT_EXTENDED}
    source ${ENTRYPOINT_EXTENDED}
  fi
}

START_DAEMON() {
  BROADCAST_MSG "STARTING DAEMON... $@"
  exec "$@"
}
