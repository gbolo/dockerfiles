#!/bin/sh

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

    echo "starting with gosu ...";
    exec /usr/local/bin/gosu ${CONTAINER_UID} "$@"


# The container has ben started as non-root, there is nothing much to do here
else

    echo "Started as non-root ..."
    echo "uid: $(id -u), gid: $(id -g) ...";

    echo "";
    exec "$@"
fi
