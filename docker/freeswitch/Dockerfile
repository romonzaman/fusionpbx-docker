FROM --platform=amd64 debian:bullseye

ARG SIGNALWIRE_PASSWORD


RUN apt-get update -y
RUN apt-get install -y gnupg2 wget lsb-release
RUN wget --http-user=signalwire --http-password=$SIGNALWIRE_PASSWORD -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg
RUN echo "machine freeswitch.signalwire.com login signalwire password $SIGNALWIRE_PASSWORD" > /etc/apt/auth.conf
RUN chmod 600 /etc/apt/auth.conf
RUN echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list
RUN echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list
RUN apt-get update -y
RUN apt-get install -y freeswitch freeswitch-conf-vanilla
RUN apt-get install -y freeswitch-mod-console freeswitch-mod-logfile freeswitch-mod-enum freeswitch-mod-event-socket freeswitch-mod-sofia
RUN apt-get install -y freeswitch-mod-commands freeswitch-mod-dptools freeswitch-mod-expr freeswitch-mod-dialplan-xml freeswitch-mod-say-en
RUN apt-get install -y freeswitch-mod-sndfile freeswitch-mod-local-stream freeswitch-mod-tone-stream freeswitch-mod-db freeswitch-mod-native-file
RUN apt-get install -y freeswitch-mod-png freeswitch-mod-esf freeswitch-mod-av freeswitch-mod-opus freeswitch-mod-ilbc
RUN apt-get install -y freeswitch-mod-lua freeswitch-mod-valet-parking freeswitch-mod-conference freeswitch-mod-voicemail freeswitch-mod-fifo
RUN apt-get install -y freeswitch-mod-pgsql freeswitch-mod-spandsp freeswitch-mod-callcenter freeswitch-mod-flite

# FusionPBX required modules
RUN apt-get install -y freeswitch-mod-curl freeswitch-mod-hash freeswitch-mod-http-cache freeswitch-mod-shout freeswitch-mod-xml-cdr freeswitch-mod-local-stream
RUN apt-get install -y freeswitch-mod-loopback freeswitch-mod-sms

# FusionPBX Specific configuration
RUN mkdir -p /var/cache/fusionpbx
RUN chown -R www-data:www-data /var/cache/fusionpbx

RUN apt-get install -y lua5.2 lua5.2-dev luarocks 
RUN apt-get install -y postgresql-server-dev-13 libssl-dev git
RUN git config --global url."https://".insteadOf git://

RUN luarocks install luajson
RUN luarocks install inspect
RUN luarocks install lpeg
RUN cp /usr/local/lib/lua/5.2/lpeg.so /usr/local/share/lua/5.2/
RUN luarocks install luasql-postgres PGSQL_INCDIR=/usr/include/postgresql

RUN apt install procps net-tools nano mlocate -y
COPY ./docker/freeswitch/docker-entrypoint.sh /

VOLUME ["/tmp", "/var/cache/fusionpbx", "/var/lib/freeswitch/storage/voicemail", "/etc/freeswitch", "/usr/share/freeswitch/scripts"]

SHELL       ["/bin/bash"]
HEALTHCHECK --interval=15s --timeout=5s \
    CMD  fs_cli -x status | grep -q ^UP || exit 1

EXPOSE 8021/tcp
EXPOSE 5060/udp

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["freeswitch"]
