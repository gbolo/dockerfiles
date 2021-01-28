#!/usr/bin/env bash
RESOURCE_DIR="${1}"
RESOURCE_ORDER="user asset filter handler check"

if [ -d ${RESOURCE_DIR} ]; then
  for r in ${RESOURCE_ORDER}; do
    for f in $(ls ${RESOURCE_DIR}/${r}_*.yaml); do
      echo "sensuctl create from file: ${f}"
      sensuctl create -f ${f}
    done
  done
else
  echo "dir: ${RESOURCE_DIR} not present"
  exit 1
fi
