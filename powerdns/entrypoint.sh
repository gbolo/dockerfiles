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

# PRE-START BOOTSTRAP LOGIC ----------------------------------------------------
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

mysql_connect_db() {
  mysql -h ${PDNS_MYSQL_HOST} -u ${PDNS_MYSQL_USER} -p${PDNS_MYSQL_PASSWORD} \
    -e "USE ${PDNS_MYSQL_DBNAME};"
  if [ $? -eq 0 ]; then
    echo "Connection attempt successful"
    MYSQL_CONNECTION_SUCCESS=1
  else
    echo "waiting 5 seconds before next attempt"
    sleep 5
  fi
}

mysql_query() {
  local MYSQL_QUERY=${1}
  mysql -r -N -h ${PDNS_MYSQL_HOST} -u ${PDNS_MYSQL_USER} -p${PDNS_MYSQL_PASSWORD} \
    -e "${MYSQL_QUERY}" ${PDNS_MYSQL_DBNAME}
}

mysql_import_schema() {
  pdns_tables=$(mysql_query "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '${PDNS_MYSQL_DBNAME}';")
  if [ ${pdns_tables} -lt 1 ]; then
    echo "Initializing Mysql database schema"
    mysql -r -N -h ${PDNS_MYSQL_HOST} -u ${PDNS_MYSQL_USER} -p${PDNS_MYSQL_PASSWORD} \
      ${PDNS_MYSQL_DBNAME} < /etc/pdns/schemas/schema.mysql.sql
  fi
}

init_mysql() {
  if [ -z "${PDNS_MYSQL_HOST}" ] || [ -z "${PDNS_MYSQL_USER}" ] || [ -z "${PDNS_MYSQL_PASSWORD}" ]; then
    echo '!! Initializing of mysql backend cannot complete without all the required env variables set: '
    echo '   PDNS_MYSQL_HOST, PDNS_MYSQL_USER, PDNS_MYSQL_PASSWORD'
  else
    echo "Attempt connection to mysql server: ${PDNS_MYSQL_HOST} ..."
    ATTEMPTS_REMAINING=12
    MYSQL_CONNECTION_SUCCESS=0
    until [ ${MYSQL_CONNECTION_SUCCESS} -gt 0 ] || [ ${ATTEMPTS_REMAINING} -le 0 ]; do
      echo "Connection attempts remaining: ${ATTEMPTS_REMAINING}"
      mysql_connect_db
      ATTEMPTS_REMAINING=$(expr ${ATTEMPTS_REMAINING} - 1)
    done
    if [ ${ATTEMPTS_REMAINING} -le 0 ]; then
      echo "!! Exiting: Exhausted attempts to connect to mysql server."
      exit 1
    fi
    echo "Creating database (if it does not already exist)"
    mysql_query "CREATE DATABASE IF NOT EXISTS ${PDNS_MYSQL_DBNAME};"
    mysql_import_schema
  fi
}

# prepare backend(s)
if [ -z "${PDNS_LAUNCH##*gsqlite3*}" ]; then
  echo "> Detected gsqlite3. Preparing sqlite backend ..."
  init_sqlite3
  mv /etc/pdns/conf.d/gsqlite3.conf.disabled /etc/pdns/conf.d/gsqlite3.conf
fi

if [ -z "${PDNS_LAUNCH##*gmysql*}" ]; then
  echo "> Detected mysql. Preparing mysql backend ..."
  init_mysql
  mv /etc/pdns/conf.d/gmysql.conf.disabled /etc/pdns/conf.d/gmysql.conf
fi

# START PDNS -------------------------------------------------------------------
echo "> Starting pdns ..."
if [ $# -eq 0 ]; then
  echo "> Executing as uid [$(/usr/bin/id -u)]: pdns_server --daemon=no --write-pid=yes"
  pdns_server --daemon=no --write-pid=yes &
else
  echo "> Executing as uid [$(/usr/bin/id -u)]: pdns_server --daemon=no --write-pid=yes ${@}"
  pdns_server --daemon=no --write-pid=yes "$@" &
fi

# SIGNAL HANDLING --------------------------------------------------------------
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
