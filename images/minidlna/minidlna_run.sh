#!/bin/sh

sed -i "s/#friendly_name=.*/friendly_name=${FRIENDLY_NAME:-Media Server}/" /etc/minidlna.conf

exec /usr/sbin/minidlnad -d -u ${PUID:-1000} -g ${PGID:-100}
