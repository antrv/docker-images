FROM alpine

RUN apk upgrade --no-cache && apk add --no-cache samba

COPY smb_run.sh /usr/sbin
COPY smb.template.conf /etc/samba

RUN chmod +x /usr/sbin/smb_run.sh

VOLUME /shares/data /shares/home

EXPOSE 445/tcp 5335/tcp 5335/udp

ENTRYPOINT ["sh", "-c", "/usr/sbin/smb_run.sh"]
