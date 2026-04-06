FROM alpine AS wsdd2-build

RUN apk upgrade
RUN apk add binutils gcc make build-base readline-dev openssl-dev ncurses-dev make gnu-libiconv zlib-dev musl-dev linux-headers git

WORKDIR /usr/src
RUN git clone https://github.com/antrv/wsdd2.git && \
    cd wsdd2 && \
    make

FROM alpine

RUN apk upgrade --no-cache

COPY --from=wsdd2-build /usr/src/wsdd2/wsdd2 /usr/sbin

EXPOSE 5335/tcp 5335/udp

ENTRYPOINT ["sh", "-c", "/usr/sbin/wsdd2 -H ${MACHINENAME:-SERVER} -N ${MACHINENAME:-SERVER} -G ${WORKGROUP:-WORKGROUP}"]
