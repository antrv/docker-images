FROM debian:13-slim

ARG IMAGE_TAG=1.0.25
ARG IMAGE_PLATFORMS=linux/amd64
ARG IVENTOY_VER=$IMAGE_TAG

RUN DEBIAN_FRONTEND=noninteractive apt update && apt upgrade -y && rm -rf /var/lib/apt/lists/*

ADD https://github.com/ventoy/PXE/releases/download/v$IVENTOY_VER/iventoy-$IVENTOY_VER-linux-free.tar.gz /tmp/iventoy.tar.gz
RUN tar -xf /tmp/iventoy.tar.gz -C /opt
RUN mv /opt/iventoy-$IVENTOY_VER /opt/iventoy

VOLUME /opt/iventoy/iso

EXPOSE 68/udp 69/udp 10809/tcp 16000/tcp 26000/tcp

ENTRYPOINT ["bash", "-c", "cd /opt/iventoy && ./iventoy.sh -R start && sleep 5 && tail -f log/log.txt"]
