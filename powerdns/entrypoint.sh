#!/bin/sh

#
#  POWERDNS DEFAULT ENTRYPOINT
#    for use with image: gbolo/pdns
#

# execute entrypoint-base ------------------------------------------------------
/entrypoints/entrypoint-base

# print pdns image info --------------------------------------------------------
echo "> Executed entrypoint-pdns on: $(date)"
echo "> PowerDNS environment variables:"
env | grep PDNS_

# CONFD ------------------------------------------------------------------------
echo "> Invoking confd to generate default pdns configs ..."
/usr/local/bin/confd -version
/usr/local/bin/confd -confdir /etc/confd.pdns -onetime -backend env

# PDNS -------------------------------------------------------------------------
create_dir() {
  if [ ! -d ${1} ]; then
    echo "Creating missing directory ${1}"
    mkdir -p ${1}
  fi
}

init_sqlite3() {
  if [ ! -f "${PDNS_GSQLITE3_DATABASE}" ]; then
    create_dir $(dirname ${PDNS_GSQLITE3_DATABASE})
    echo "Initializing ${PDNS_GSQLITE3_DATABASE}"
    cat /etc/pdns/schemas/schema.sqlite3.sql | sqlite3 ${PDNS_GSQLITE3_DATABASE}
    echo "Setting permissions recursively"
    chmod -R 770 $(dirname ${PDNS_GSQLITE3_DATABASE})
    chown -R pdns:pdns $(dirname ${PDNS_GSQLITE3_DATABASE})
  else
    echo "${PDNS_GSQLITE3_DATABASE} already exists"
  fi
}

# prepare backend(s)
case "${PDNS_LAUNCH}" in
*gsqlite3*)
  echo "> Detected gsqlite3. Preparing sqlite backend ..."
  init_sqlite3
  ;;
*)
  echo "> Could not detect a pdns backend to init ..."
  ;;
esac

# start pdns
echo "> Starting pdns ..."
if [ $# -eq 0 ]; then
  echo "> Executing as uid [$(/usr/bin/id -u)]: pdns_server --daemon=no --write-pid=yes"
  pdns_server --daemon=no --write-pid=yes &
else
  echo "> Executing as uid [$(/usr/bin/id -u)]: pdns_server --daemon=no --write-pid=yes ${@}"
  pdns_server --daemon=no --write-pid=yes "$@" &
fi

# catch signals and do graceful shutdown and reload
PDNS_PID_FILE=/tmp/pdns.pid

shutdown_pdns() {
  echo "!! Recieved signal to gracefully shutdown pdns"
  local pid=$(cat ${PDNS_PID_FILE})
  pdns_control quit
  # wait
  wait_for_pid_to_exit ${pid}
  exit 0
}

reload_pdns() {
  echo "!! Recieved signal to reload pdns"
  pdns_control cycle
  wait $(cat ${PDNS_PID_FILE})
}

wait_for_pid_to_exit() {
  local pid=${1}
  echo "waiting for pid [${pid}] to exit ..."
  while [ -d /proc/${pid} ]; do
    echo "pid [${pid}] still exists. waiting ..."
    sleep 1
  done
}

trap "reload_pdns" SIGHUP
trap "shutdown_pdns" SIGINT SIGTERM

wait
