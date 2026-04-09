FROM alpine

RUN apk --no-cache upgrade && apk --no-cache add minidlna

COPY minidlna_run.sh /usr/sbin
RUN chmod +x /usr/sbin/minidlna_run.sh

ENV FRIENDLY_NAME=Media\ Server

VOLUME /opt

EXPOSE 1900/udp 8200/tcp

CMD ["sh", "-c", "/usr/sbin/minidlna_run.sh"]
