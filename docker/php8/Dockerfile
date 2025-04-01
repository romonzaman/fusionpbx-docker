FROM --platform=linux/amd64 debian:bookworm

ENV user=www-data
ENV group=www-data

#set the environment path
RUN export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y

#Add dependencies
RUN apt-get update -y && apt-get install -y apt-transport-https gnupg2 nano procps net-tools curl wget lsb-release systemd systemd-sysv ca-certificates dialog nano net-tools git && \
    wget -qO- https://packages.sury.org/php/apt.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sury-php-8.x.gpg && \
    chmod 644 /etc/apt/trusted.gpg.d/sury-php-8.x.gpg && \
    echo "deb https://packages.sury.org/php/ bookworm main" > /etc/apt/sources.list.d/php.list && \
    apt-get update -y && apt-get install -y php8.1 php8.1-cli php8.1-fpm php8.1-pgsql php8.1-sqlite3 php8.1-odbc php8.1-curl php8.1-imap php8.1-xml php8.1-gd

#add the cache directory
#RUN mkdir -p /var/cache/fusionpbx
#RUN mkdir -p /etc/fusionpbx

RUN sed 's#post_max_size = .*#post_max_size = 80M#g' -i /etc/php/8.1/fpm/php.ini
RUN sed 's#upload_max_filesize = .*#upload_max_filesize = 80M#g' -i /etc/php/8.1/fpm/php.ini
RUN sed 's#;max_input_vars = .*#max_input_vars = 8000#g' -i /etc/php/8.1/fpm/php.ini
RUN sed 's#; max_input_vars = .*#max_input_vars = 8000#g' -i /etc/php/8.1/fpm/php.ini

EXPOSE 9000/tcp

COPY ./docker/php8/www.conf /etc/php/8.1/fpm/pool.d/www.conf
RUN mkdir -p /run/php/

WORKDIR /var/www/fusionpbx
VOLUME ["/var/cache/fusionpbx/", "/var/www/fusionpbx"]

CMD [ "php-fpm8.1", "-F", "-y", "/etc/php/8.1/fpm/php-fpm.conf" ]
