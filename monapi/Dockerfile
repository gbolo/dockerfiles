# For Educational Purposes only.
FROM golang:1.8-alpine
LABEL maintainer "George Bolo <gbolo@linuxctl.com>"

# Install Application
ENV MONAPI_CFG_PATH /etc/monapi
RUN apk add --update git && \
    go get github.com/gbolo/go-monapi 

EXPOSE 8080
ENTRYPOINT ["/go/bin/go-monapi"]
