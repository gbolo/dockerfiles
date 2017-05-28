#!/bin/sh

# functions
function H5AI_CONFIG {

  # set default values for variables
  # this hash is: changeme
  export H5AI_PASSWORD=${H5AI_PASSWORD:-"f1891cea80fc05e433c943254c6bdabc159577a02a7395dfebbfbc4f7661d4af56f2d372131a45936de40160007368a56ef216a30cb202c66d3145fd24380906"}
  # run confd to render out the config
  /usr/local/bin/confd -onetime -backend env

}

# The container has been started as the root user
if [ "$(id -u)" -eq 0 ]; then

    # Generating a random UID and GID between 5,000 and 20,000
    # CONTAINER_UID=$(( RANDOM % (20000 - 5000 + 1 ) + 5000 ))
    # CONTAINER_GID=$(( RANDOM % (20000 - 5000 + 1 ) + 5000 ))

    # Use the nobody user/group for now
    CONTAINER_UID=65534
    CONTAINER_GID=65534

    echo "Started as uid 0, using nobody user/group ...";
    echo "uid: ${CONTAINER_UID}, gid: ${CONTAINER_GID} ...";

    echo "Running confd ..."
    H5AI_CONFIG
    ## TODO: figure out why:
    # Started as uid 0, using nobody user/group ...
    # uid: 65534, gid: 65534 ...
    # starting with gosu ...
    # [28-May-2017 18:05:21] ERROR: failed to open error_log (/proc/self/fd/2): Permission denied (13)
    # [28-May-2017 18:05:21] ERROR: failed to post process the configuration
    # [28-May-2017 18:05:21] ERROR: FPM initialization failed

    # echo "starting with gosu ...";
    # exec /usr/local/bin/gosu ${CONTAINER_UID} "$@"
    echo "Starting as root for now ...";
    exec "$@"

# The container has ben started as non-root, there is nothing much to do here
else

    echo "Started as non-root ..."
    echo "uid: $(id -u), gid: $(id -g) ...";

    echo "Running confd ..."
    H5AI_CONFIG
    
    echo "";
    exec "$@"
fi
