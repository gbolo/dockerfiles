set -e
ASSETS_DIR=./assets
docker run -it --rm -v $(pwd)/${ASSETS_DIR}:/artifacts -w="/tmp" -v $(pwd)/build_mackerelio.sh:/tmp/build_mackerelio.sh golang:alpine /bin/sh build_mackerelio.sh /artifacts
docker run -it --rm -v $(pwd)/${ASSETS_DIR}:/artifacts -w="/tmp" -v $(pwd)/build_mackerelio.sh:/tmp/build_mackerelio.sh golang:latest /bin/bash build_mackerelio.sh /artifacts
