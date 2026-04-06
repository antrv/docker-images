FROM alpine:3.20 AS build

ARG IMAGE_TAG=4.44
ARG SOFTETHER_VER=$IMAGE_TAG-9807-rtm
ARG SOFTETHER_DIR=SoftEtherVPN_Stable-$SOFTETHER_VER
ARG SOFTETHER_ARCHIVE=$SOFTETHER_DIR.tar.gz
ARG SOFTETHER_LINK=https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/archive/refs/tags/v${SOFTETHER_VER}.tar.gz

ARG INSTALL_DIR_NAME=softethervpn
ARG INSTALL_DIR=/opt/$INSTALL_DIR_NAME

RUN apk update
RUN apk upgrade
RUN apk add binutils gcc make build-base readline-dev openssl-dev ncurses-dev make gnu-libiconv zlib-dev musl-dev

WORKDIR /tmp
ADD $SOFTETHER_LINK /tmp/$SOFTETHER_ARCHIVE
RUN tar -xf $SOFTETHER_ARCHIVE -C ./

WORKDIR /tmp/$SOFTETHER_DIR
RUN ./configure
RUN make
RUN mkdir -p $INSTALL_DIR
RUN make INSTALL_VPNSERVER_DIR=$INSTALL_DIR/ INSTALL_VPNCMD_DIR=$INSTALL_DIR/ \
         INSTALL_BIN_DIR=$INSTALL_DIR/ INSTALL_VPNBRIDGE_DIR=$INSTALL_DIR/ INSTALL_VPNCLIENT_DIR=$INSTALL_DIR/ install

WORKDIR /opt
RUN tar -czf $INSTALL_DIR_NAME.tar.gz $INSTALL_DIR_NAME

# --------------------------------------

FROM alpine:3.20

RUN apk update
RUN apk upgrade
RUN apk add ca-certificates readline gnu-libiconv zlib dhclient
RUN rm -rf /var/cache/apk/*

ARG INSTALL_DIR_NAME=softethervpn
ARG INSTALL_DIR=/opt/$INSTALL_DIR_NAME
ARG CONFIG_DIR=/etc/$INSTALL_DIR_NAME
ARG LOG_DIR=/var/log/$INSTALL_DIR_NAME
ARG ARCHIVE_NAME=$INSTALL_DIR_NAME.tar.gz

ENV VPN_INSTALL_DIR=$INSTALL_DIR
ENV VPN_CONFIG_DIR=$CONFIG_DIR

WORKDIR /opt
COPY --from=build /opt/$ARCHIVE_NAME .
RUN tar -xf $ARCHIVE_NAME
RUN rm $ARCHIVE_NAME

WORKDIR $INSTALL_DIR
COPY run.sh .
RUN chmod +x run.sh

RUN mkdir -p $CONFIG_DIR

# Create log directories and symlink to installation directory
RUN mkdir -p $LOG_DIR/packet_log && ln -sf $LOG_DIR/packet_log $INSTALL_DIR/packet_log
RUN mkdir -p $LOG_DIR/security_log && ln -sf $LOG_DIR/security_log $INSTALL_DIR/security_log
RUN mkdir -p $LOG_DIR/client_log && ln -sf $LOG_DIR/client_log $INSTALL_DIR/client_log
RUN mkdir -p $LOG_DIR/server_log && ln -sf $LOG_DIR/server_log $INSTALL_DIR/server_log
RUN mkdir -p $LOG_DIR/bridge_log && ln -sf $LOG_DIR/bridge_log $INSTALL_DIR/bridge_log

VOLUME $LOG_DIR, $CONFIG_DIR

#EXPOSE 500/udp 1194/tcp 1194/udp 1701/udp 4500/udp 5555/tcp

CMD ["sh", "-c", "$VPN_INSTALL_DIR/run.sh"]
