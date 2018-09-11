FROM alpine:3.8

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz /tmp/

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /
RUN rm /tmp/s6-overlay-amd64.tar.gz

RUN apk update
RUN apk add --no-cache openrc vlan libressl openssh-server

##
## Add the `firstboot` file to /etc/init.d
##

COPY config/init.d/firstboot /etc/init.d/firstboot

##
## Add SSHD configuration
##

COPY config/sshd/sshd_config /etc/ssh/sshd_config

##
## INIT
##

ENTRYPOINT [ "/init" ]