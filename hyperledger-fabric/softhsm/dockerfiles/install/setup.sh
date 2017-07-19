#!/usr/bin/env bash
################################################################################
#
#   simple install script for hyperledger fabric
#   intended to be used for testing pkcs11 with gbolo/fabric-* docker images
#
################################################################################

if [ $# -eq 0 ]
  then
    echo "Must Supply 1 argument: peer, orderer, ca, tools"
    exit
fi


# Variables
APT_PKGS='zlib1g-dev libbz2-dev libyaml-dev libltdl-dev libtool curl ca-certificates openssl git'
LD_FLAGS="-X github.com/hyperledger/fabric/common/metadata.Version=${PROJECT_VERSION} \
          -X github.com/hyperledger/fabric/common/metadata.BaseVersion=${BASEIMAGE_RELEASE} \
          -X github.com/hyperledger/fabric/common/metadata.BaseDockerLabel=org.hyperledger.fabric \
          -X github.com/hyperledger/fabric/common/metadata.DockerNamespace=hyperledger \
          -X github.com/hyperledger/fabric/common/metadata.BaseDockerNamespace=hyperledger"

# install prereqs
INSTALL_PREREQS() {
  apt-get update
  apt-get install -y ${APT_PKGS}
}

# remove prereqs
REMOVE_PREREQS() {
  apt-get remove -y ${APT_PKGS}
  rm -rf /var/lib/apt/lists/*
}

# clone fabric-ca
CLONE_FABRIC_CA() {
  mkdir -p ${GOPATH}/src/github.com/hyperledger/fabric-ca
  git clone --single-branch -b master https://github.com/hyperledger/fabric-ca ${GOPATH}/src/github.com/hyperledger/fabric-ca
  cd ${GOPATH}/src/github.com/hyperledger/fabric-ca
  git checkout ${FABRIC_TAG}
}

# compile fabric-ca-client
COMPILE_FABRIC_CA_CLIENT() {
  cd ${GOPATH}/src/github.com/hyperledger/fabric-ca/cmd/fabric-ca-client
  ${GOROOT}/bin/go build -o /usr/local/bin/fabric-ca-client
}

# compile fabric-ca-server
COMPILE_FABRIC_CA_SERVER() {
  cd ${GOPATH}/src/github.com/hyperledger/fabric-ca/cmd/fabric-ca-server
  ${GOROOT}/bin/go build -o /usr/local/bin/fabric-ca-server
}

# clone fabric-peer
CLONE_FABRIC_PEER() {
  mkdir -p ${GOPATH}/src/github.com/hyperledger/fabric
  git clone https://github.com/hyperledger/fabric ${GOPATH}/src/github.com/hyperledger/fabric
  cd ${GOPATH}/src/github.com/hyperledger/fabric/peer
  git checkout ${FABRIC_TAG}
}

# compile fabric-peer
COMPILE_FABRIC_PEER() {
  cd ${GOPATH}/src/github.com/hyperledger/fabric/peer
  ${GOROOT}/bin/go build -o /usr/local/bin/peer -ldflags "$LD_FLAGS"
}

# compile fabric-orderer
COMPILE_FABRIC_ORDERER() {
  cd ${GOPATH}/src/github.com/hyperledger/fabric/orderer
  ${GOROOT}/bin/go build -o /usr/local/bin/orderer -ldflags "$LD_FLAGS"
}

# compile tools
COMPILE_FABRIC_TOOLS() {
  for tool in cryptogen configtxlator; do
    cd ${GOPATH}/src/github.com/hyperledger/fabric/common/tools/${tool}
    ${GOROOT}/bin/go build -o /usr/local/bin/${tool} \
      -ldflags "-X github.com/hyperledger/fabric/common/tools/${tool}/metadata.Version=${PROJECT_VERSION}"
  done

  cd ${GOPATH}/src/github.com/hyperledger/fabric/common/configtx/tool/configtxgen
  ${GOROOT}/bin/go build -o /usr/local/bin/configtxgen \
    -ldflags "-X github.com/hyperledger/fabric/common/configtx/tool/configtxgen/metadata.Version=${PROJECT_VERSION}"
}

# install fabric-cli
INSTALL_FABRIC_CLI() {
  mkdir -p ${GOPATH}/src/github.com/securekey/fabric-examples
  git clone https://github.com/securekey/fabric-examples ${GOPATH}/src/github.com/securekey/fabric-examples
  cd ${GOPATH}/src/github.com/securekey/fabric-examples/fabric-cli/cmd/fabric-cli
  ${GOROOT}/bin/go build -o /usr/local/bin/fabric-cli
}

# setup Golang
SETUP_GOLANG() {
  export GOPATH=/opt/gopath
  export GOROOT=/opt/go
  mkdir -p ${GOPATH}
  curl -sL -o /tmp/go.tgz https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz
  tar -xvf /tmp/go.tgz -C /opt/
  rm -rf /tmp/go.tgz
}

# setup softhsm2
SETUP_SOFTHSM() {
  # Install softhsm2 package
  apt-get -y install softhsm2

  # Create tokens directory
  mkdir -p /var/lib/softhsm/tokens/

  # Initialize token
  softhsm2-util --init-token --slot 0 --label "ForFabric" --so-pin 1234 --pin 98765432
}

# cleanup
CLEANUP() {
  REMOVE_PREREQS
  rm -rf /opt/go*
}

if [ $1 = "peer" ]; then
  INSTALL_PREREQS
  SETUP_GOLANG
  CLONE_FABRIC_CA
  COMPILE_FABRIC_CA_CLIENT
  CLONE_FABRIC_PEER
  COMPILE_FABRIC_PEER
  mkdir -p ${FABRIC_CFG_PATH} \
    /var/hyperledger/db \
    /var/hyperledger/production
  cp -rp ${GOPATH}/src/github.com/hyperledger/fabric/sampleconfig/core.yaml ${FABRIC_CFG_PATH}/

elif [ $1 = "orderer" ]; then
  INSTALL_PREREQS
  SETUP_GOLANG
  CLONE_FABRIC_CA
  COMPILE_FABRIC_CA_CLIENT
  CLONE_FABRIC_PEER
  COMPILE_FABRIC_ORDERER
  mkdir -p ${FABRIC_CFG_PATH}
  cp -rp ${GOPATH}/src/github.com/hyperledger/fabric/sampleconfig/orderer.yaml ${FABRIC_CFG_PATH}/

elif [ $1 = "ca" ]; then
  INSTALL_PREREQS
  SETUP_GOLANG
  CLONE_FABRIC_CA
  COMPILE_FABRIC_CA_CLIENT
  COMPILE_FABRIC_CA_SERVER
  mkdir -p ${FABRIC_CA_HOME} \
    /var/hyperledger/fabric-ca-server

elif [ $1 = "tools" ]; then
  INSTALL_PREREQS
  SETUP_GOLANG
  CLONE_FABRIC_CA
  COMPILE_FABRIC_CA_CLIENT
  CLONE_FABRIC_PEER
  COMPILE_FABRIC_TOOLS
  INSTALL_FABRIC_CLI

else
  echo "Invalid Argument: ${1}. Valid Argument: peer, orderer, ca, tools"
  exit

fi

# finally
cp /tmp/install/entrypoint.sh /usr/local/bin/
chmod +x /usr/local/bin/*
SETUP_SOFTHSM
CLEANUP
