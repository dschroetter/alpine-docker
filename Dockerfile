FROM alpine:3.8

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz /tmp/

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /
RUN rm /tmp/s6-overlay-amd64.tar.gz

RUN apk update
RUN apk add openssh-server

##
## Add SSHD Service
##

##
## INIT
##

ENTRYPOINT [ "/init" ]