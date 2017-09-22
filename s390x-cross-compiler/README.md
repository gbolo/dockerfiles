# s390x Cross Compiler
This container is intended for cross compiling binaries for s390x Arch.
**WARNING** For testing purposes only!

# Example Usage
```
# Run container interactively
docker run -it --rm gbolo/cross-compile:s390x

# Get source code
root@aca90b042dc8:/# mkdir -p ${GOPATH}/src/github.com/hyperledger/fabric
root@aca90b042dc8:/# git clone https://github.com/hyperledger/fabric ${GOPATH}/src/github.com/hyperledger/fabric
Cloning into '/opt/gopath/src/github.com/hyperledger/fabric'...
remote: Counting objects: 42858, done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 42858 (delta 3), reused 8 (delta 3), pack-reused 42843
Receiving objects: 100% (42858/42858), 50.59 MiB | 7.56 MiB/s, done.
Resolving deltas: 100% (25811/25811), done.

# Compile it
root@aca90b042dc8:/# cd ${GOPATH}/src/github.com/hyperledger/fabric/peer
root@aca90b042dc8:/opt/gopath/src/github.com/hyperledger/fabric/peer# go build -o peer-amd64 .
root@aca90b042dc8:/opt/gopath/src/github.com/hyperledger/fabric/peer# GOARCH=s390x GOOS=linux CC=s390x-linux-gnu-gcc CGO_ENABLED=1 go build -o peer-s390x -tags nopkcs11 .
root@aca90b042dc8:/opt/gopath/src/github.com/hyperledger/fabric/peer# file peer-*
peer-amd64: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, not stripped
peer-s390x: ELF 64-bit MSB executable, IBM S/390, version 1 (SYSV), statically linked, not stripped
```
