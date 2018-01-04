# PowerDNS Docker Image: [gbolo/pdns:latest](https://hub.docker.com/r/gbolo/pdns/)

[![Docker Automated build](https://img.shields.io/docker/automated/gbolo/pdns.svg)]()
[![Docker Build Status](https://img.shields.io/docker/build/gbolo/pdns.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/gbolo/pdns.svg)]()

## Features

Light weight, Alpine based pdns (PowerDNS) docker image available at: [gbolo/pdns:latest](https://hub.docker.com/r/gbolo/pdns/)

### gbolo/baseos:alpine base image
 - inherits all features found in [gbolo/baseos:alpine](https://hub.docker.com/r/gbolo/baseos)

### templated configuration files
 - dynamically generated configs based on the following environment variables **(NOTE: if no value is specified then the image does not set the env variable by default)**:
 ```
  # Available environment variables with their default values
  PDNS_LAUNCH="gsqlite3,bind"
  PDNS_THREADS=1
  PDNS_MAX_CACHE_ENTRIES=1000000
  PDNS_CACHE_TTL=60
  PDNS_QUERY_CACHE_TTL=20
  PDNS_ENABLE_WEBSERVER=yes
  PDNS_WEBSERVER_PORT=8081
  PDNS_ENABLE_API=yes
  PDNS_API_KEY=changeme
  PDNS_LOGLEVEL=3

  # Backend config - sqlite3
  PDNS_GSQLITE3_DATABASE=/etc/pdns/data/powerdns.sqlite3.db
  PDNS_GSQLITE3_SYNCHRONOUS
  PDNS_GSQLITE3_FOREIGN_KEYS
  PDNS_GSQLITE3_DNSSEC

  # Backend config - mysql
  PDNS_MYSQL_HOST
  PDNS_MYSQL_PORT
  PDNS_MYSQL_SOCKET
  PDNS_MYSQL_DBNAME
  PDNS_MYSQL_USER
  PDNS_MYSQL_GROUP
  PDNS_MYSQL_PASSWORD
  PDNS_MYSQL_DNSSEC
  PDNS_MYSQL_INNODB_READ_COMMITTED
  PDNS_MYSQL_TIMEOUT
 ```
### automated configuration of `sqlite3` backend
 - automatically detected via `PDNS_LAUNCH` environment variable
 - database file can be specified with `PDNS_GSQLITE3_DATABASE` environment variable
 - database file is **automatically initialized** with schema when:
   * `PDNS_LAUNCH` is configured to use it **AND** `PDNS_GSQLITE3_DATABASE` does not already exist

### automated configuration of `mysql` backend
 - automatically detected via `PDNS_LAUNCH` environment variable
 - all environment variables for this backend are specified above
 - entrypoint logic will attempt to connect to mysql server prior to starting pdns, to validate connection details
 - database schema is automatically applied when:
   * `PDNS_LAUNCH` is configured to use it **AND** `PDNS_MYSQL_DBNAME` has no tables

### support for additional flags
additional flags to `pdns_server` can be specified at runtime with `CMD`. for example:
```
# additional flags can be added at runtime (--guardian=no)
docker run --name pdns \
  -p 1053:53 \
  -p 1053:53/udp \
  -e PDNS_LAUNCH=gsqlite3 \
  -e PDNS_ENABLE_API=no \
  gbolo/pdns \
    --guardian=no
```

## Example Usage
```
# run with API and webserver enabled, and sqlite3 backend
docker run --name pdns \
  -p 1053:53 \
  -p 1053:53/udp \
  -p 8081:8081 \
  -e PDNS_LAUNCH=gsqlite3 \
  -e PDNS_ENABLE_API=yes \
  -e PDNS_API_KEY=secret \
  gbolo/pdns

# run with a mysql server backend
docker run --name pdns \
  -p 1053:53 \
  -p 1053:53/udp \
  -p 8081:8081 \
  -e PDNS_LAUNCH=gmysql \
  -e PDNS_MYSQL_HOST=db.linuxctl.dkr \
  -e PDNS_MYSQL_DBNAME=pdns \
  -e PDNS_MYSQL_USER=powerdns \
  -e PDNS_MYSQL_PASSWORD=changeme \
  gbolo/pdns
```

## Example Output
**NOTE:** output of entrypoint is purposely very verbose and cannot be toned down :)
```
# output (logs) when running mysql backend

> Executed entrypoint-base on: Thu Jan  4 04:57:57 GMT 2018
> Version Information:
BASEOS_BUILD_DATE=2017-12-31
BASEOS_BUILD_REF=b07930d
!! Exiting entrypoint-base
> Executed entrypoint-pdns on: Thu Jan  4 04:57:57 GMT 2018
> PowerDNS environment variables:
PDNS_ENABLE_API=yes
PDNS_MYSQL_PASSWORD=changeme
PDNS_API_KEY=changeme
PDNS_GSQLITE3_DATABASE=/etc/pdns/data/powerdns.sqlite3.db
PDNS_MYSQL_HOST=db.linuxctl.dkr
PDNS_MYSQL_USER=powerdns
PDNS_ENABLE_WEBSERVER=yes
PDNS_QUERY_CACHE_TTL=20
PDNS_MAX_CACHE_ENTRIES=1000000
PDNS_LAUNCH=gmysql
PDNS_CACHE_TTL=60
PDNS_THREADS=1
PDNS_LOGLEVEL=3
PDNS_WEBSERVER_PORT=8081
PDNS_MYSQL_DBNAME=pdns
> Invoking confd to generate default pdns configs ...
confd 0.14.0 (Git SHA: 9fab9634, Go Version: go1.9.1)
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO Backend set to env
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO Starting confd
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO Backend source(s) set to
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO Target config /etc/pdns/conf.d/api.conf out of sync
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO Target config /etc/pdns/conf.d/api.conf has been updated
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO Target config /etc/pdns/conf.d/gmysql.conf.disabled out of sync
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO Target config /etc/pdns/conf.d/gmysql.conf.disabled has been updated
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO Target config /etc/pdns/conf.d/gsqlite3.conf.disabled out of sync
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO Target config /etc/pdns/conf.d/gsqlite3.conf.disabled has been updated
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO /etc/pdns/pdns.conf has UID 100 should be 0
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO /etc/pdns/pdns.conf has GID 101 should be 0
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO /etc/pdns/pdns.conf has mode -rw------- should be -rw-r-----
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO /etc/pdns/pdns.conf has md5sum 677171de5c6c36a5d276dc4f0643fc91 should be 60df1ae0cf8d05acddecbad00f5a4e08
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO Target config /etc/pdns/pdns.conf out of sync
2018-01-04T04:57:57Z 166a5426aa05 /usr/local/bin/confd[26]: INFO Target config /etc/pdns/pdns.conf has been updated
> Detected mysql. Preparing mysql backend ...
Attempt connection to mysql server: db.linuxctl.dkr ...
Connection attempts remaining: 12
ERROR 2003 (HY000): Can't connect to MySQL server on 'db.linuxctl.dkr' (111 "Connection refused")
waiting 5 seconds before next attempt
Connection attempts remaining: 11
ERROR 2003 (HY000): Can't connect to MySQL server on 'db.linuxctl.dkr' (111 "Connection refused")
waiting 5 seconds before next attempt
Connection attempts remaining: 10
Connection attempt successful
Creating database (if it does not already exist)
Initializing Mysql database schema
> Starting pdns ...
> Executing as uid [0]: pdns_server --daemon=no --write-pid=yes
Jan 04 04:58:07 Guardian is launching an instance
Jan 04 04:58:07 UDP server bound to 0.0.0.0:53
Jan 04 04:58:07 UDPv6 server bound to [::]:53
Jan 04 04:58:07 TCP server bound to 0.0.0.0:53
Jan 04 04:58:07 TCPv6 server bound to [::]:53
Jan 04 04:58:07 Creating backend connection for TCP
Jan 04 04:58:07 Only asked for 1 backend thread - operating unthreaded
```
