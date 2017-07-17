


docker run -it --rm \
  -p 17054:7054 \
  -e FABRIC_CA_SERVER_BCCSP_DEFAULT=PKCS11 \
  -e FABRIC_CA_SERVER_BCCSP_PKCS11_LIBRARY=/usr/lib/softhsm/libsofthsm2.so \
  -e FABRIC_CA_SERVER_BCCSP_PKCS11_LABEL=ForFabric \
  -e FABRIC_CA_SERVER_BCCSP_PKCS11_PIN=98765432 \
  -e FABRIC_CA_SERVER_BCCSP_PKCS11_SENSITIVEKEYS=true \
  -e FABRIC_CA_SERVER_BCCSP_PKCS11_SOFTWAREVERIFY=true \
  -v $(pwd)/files/config/ca-server-1.0.0-pkcs11.yaml:/etc/hyperledger/fabric-ca-server/fabric-ca-server-config.yaml \
  gbolo/fabric-ca:1.0.0-softhsm






#  ./files/bin/fabric-ca-server-gbolo -c ./files/config/ca-server-1.0.0-pkcs11.yaml start -b admin:adminpw
