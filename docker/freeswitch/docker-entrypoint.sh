#!/bin/bash
set -e

# Source docker-entrypoint.sh:
# https://github.com/docker-library/postgres/blob/master/9.4/docker-entrypoint.sh
# https://github.com/kovalyshyn/docker-freeswitch/blob/vanilla/docker-entrypoint.sh

if [ "$1" = 'freeswitch' ]; then
    echo "Starting FreeSWITCH..."
    if [ ! -f "/etc/freeswitch/freeswitch.xml" ]; then
        mkdir -p /etc/freeswitch
        cp -varf /usr/share/freeswitch/conf/vanilla/* /etc/freeswitch/
    fi
    sed -i 's/<param name="listen-ip" value="::/<param name="listen-ip" value="0.0.0.0/' /etc/freeswitch/autoload_configs/event_socket.conf.xml
    if [ -f "/etc/freeswitch/sip_profiles/external-ipv6.xml" ]; then
        mv /etc/freeswitch/sip_profiles/external-ipv6.xml /etc/freeswitch/sip_profiles/external-ipv6.xml.noload
    fi
    if [ -f "/etc/freeswitch/sip_profiles/internal-ipv6.xml" ]; then
        mv /etc/freeswitch/sip_profiles/internal-ipv6.xml /etc/freeswitch/sip_profiles/internal-ipv6.xml.noload
    fi

    chown -R www-data:www-data /etc/freeswitch
    chown -R www-data:www-data /var/{run,lib}/freeswitch
    chown -R www-data:www-data /var/cache/fusionpbx
    chown -R www-data:www-data /var/log/freeswitch
    rm -rf /var/cache/fusionpbx/*
    if [ -d /docker-entrypoint.d ]; then
        for f in /docker-entrypoint.d/*.sh; do
            [ -f "$f" ] && . "$f"
        done
    fi
    /usr/bin/freeswitch -u www-data -g www-data -nonat -c
fi

exec "$@"
