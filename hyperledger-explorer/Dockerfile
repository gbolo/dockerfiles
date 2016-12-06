# Hyperledger Explorer docker alpine image
# https://github.com/hyperledger/blockchain-explorer
# env variables required:
# HTTP_PORT=<web server port. Default is 9090 if not set>
# HYP_REST_ENDPOINT=<REST endpoint. Default is http://127.0.0.1:7050 if not set>

FROM node:7-alpine
MAINTAINER George Bolo <gbolo@linuxctl.com>

ARG NODEUSER=nodejs
ARG BASEDIR=/home/${NODEUSER}/blockchain-explorer
ARG WORKINGDIR=${BASEDIR}/explorer_1

# -----------------------------------------------------------------------------
# Installation
# -----------------------------------------------------------------------------
RUN apk add --no-cache git bash && \
    npm install npm bower grunt-cli graceful-fs@4.1.5 minimatch@3.0.2 -g && \
    adduser -Ds /bin/bash ${NODEUSER}

USER ${NODEUSER}
RUN git clone --single-branch -b master --depth 1 https://github.com/hyperledger/blockchain-explorer ${BASEDIR}

WORKDIR ${WORKINGDIR}
RUN npm install grunt grunt-auto-install grunt-contrib-uglify grunt-contrib-copy && \
    grunt

# -----------------------------------------------------------------------------
# ENTRY POINT
# -----------------------------------------------------------------------------
CMD ["node", "exp-server.js"]

