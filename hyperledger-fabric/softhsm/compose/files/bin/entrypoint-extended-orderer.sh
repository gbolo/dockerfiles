#!/usr/bin/env bash

# Extension to existing entrypoint

# get tlscacerts in geneisis block
echo "Copying tlsca certs for genesis block creation"
cp -rp ${ORDERER_GENERAL_LOCALMSPDIR}/tlscacerts /data/adminOrg1MSP/
cp -rp ${ORDERER_GENERAL_LOCALMSPDIR}/tlscacerts /data/adminOrdererOrg1MSP/
