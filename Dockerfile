FROM alpine:3.8

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz /tmp/

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /
RUN rm /tmp/s6-overlay-amd64.tar.gz

RUN apk update
RUN apk add --no-cache openrc vlan libressl openssh-server \
    ## Set default runlevel in /etc/rc.conf
    && sed -i \
       -e 's/#rc_default_runlevel=".*"/rc_default_runlevel="default"/g'\
       /etc/rc.conf

##
## Add the `firstboot` file to /etc/init.d
##

COPY config/init.d/firstboot /etc/init.d/firstboot

##
## For testing purposes, spawn a tty
##

RUN ln -s /sbin/getty /sbin/agetty
RUN ln -s /etc/init.d/agetty /etc/init.d/agetty.tty1
RUN rc-update add agetty.tty1 default

##
## Add `firstboot` to default runlevel
##

RUN rc-update add firstboot default

##
## Add SSHD configuration
##

COPY config/sshd/sshd_config /etc/ssh/sshd_config

##
## INIT
##

ENTRYPOINT [ "/sbin/openrc-init" ]