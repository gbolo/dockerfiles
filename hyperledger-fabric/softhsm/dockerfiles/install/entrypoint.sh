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

source /usr/local/bin/entrypoint-functions.sh

#
# MAIN
#

# LOGIC FOR FABRIC-CA-SERVER
if [ ${DAEMON_TYPE} == "ca" ]; then
  if [ ${FABRIC_CA_SERVER_BCCSP_DEFAULT:-SW} == "PKCS11" ]; then
    TEST_PKCS11
  fi
# LOGIC FOR FABRIC PEER AND ORDERER
else
  if [ ${FABRIC_CA_CLIENT_BCCSP_DEFAULT:-SW} == "PKCS11" ]; then
    TEST_PKCS11
    CHECK_FOR_EXISTING_PKCS11_FABRIC_KEY
    if [ $? -lt 1 ]; then
      ENROLL_CLIENT
    fi
  else
    CHECK_FOR_EXISTING_FABRIC_KEY
    if [ $? -lt 1 ]; then
      ENROLL_CLIENT
    fi
  fi

  # ENROLL IF FOR SOME REASON WE HAVE A KEY BUT NO ECERT
  CHECK_FOR_EXISTING_FABRIC_ECERT
  if [ $? -lt 1 ]; then
    ENROLL_CLIENT
  fi
  COPY_ADMIN_CERTS
  COPY_TLSCA_CERTS
fi

# SHARED LOGIC
EXECUTE_ADDITIONAL_SCRIPT
START_DAEMON "$@"
