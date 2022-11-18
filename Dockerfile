FROM scolagreco/docker-apache24:2.4.54

COPY ./apache/conf /usr/local/apache2/conf/

ADD files /root/

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

ENV WORKDIR /var/www

RUN set -x \
    && mkdir -p "$WORKDIR" \
    && mv /root/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so \
    && apk add --update --no-cache \
                ca-certificates \
                curl \
                tar \
                xz \
                gzip \
                imagemagick \
                libressl \
                zlib \
                libxml2 \
                musl \
                libssh \
                libssh-dev \
                libssh2 \
                libssh2-dev \
                libbz2 \
                pcre \
                memcached-dev \
                libsmbclient \
                gnu-libiconv \
                gnu-libiconv-dev \
		libmcrypt \
		libmcrypt-dev \
    && apk add --update --no-cache \
                php81 \
                php81-fpm \
                php81-mysqli \
                php81-json \
                php81-openssl \
                php81-curl \
                php81-zlib \
                php81-xml \
                php81-phar \
                php81-intl \
                php81-dom \
                php81-xmlreader \
                php81-ctype \
                php81-mbstring \
                php81-gd \
                php81-iconv \
                php81-posix \
    && apk add --update --no-cache \
                php81-intl \
                php81-pdo_mysql \
                php81-pspell \
                php81-fileinfo \
                php81-opcache \
                php81-ldap \
                php81-pdo_pgsql \
                php81-pgsql \
                php81-pdo_odbc \
                php81-zip \
                php81-soap \
                php81-apcu \
                php81-session \
                php81-simplexml \
                php81-pecl-ssh2 \
    && apk add --update --no-cache \
                php81-tokenizer \
                php81-ftp \
                php81-gmp \
                php81-pdo_sqlite \
                php81-sqlite3 \
                php81-xmlwriter \
                php81-xsl \
                php81-pecl-imagick \
                php81-pecl-imagick-dev \
    && apk add --update --no-cache \
                php81-bz2 \
                php81-pecl-memcached \
                php81-redis \
                php81-imap \
                php81-exif \
                php81-pcntl \
                php81-pear \
		php81-dev \
		g++ \
    && apk add --update --no-cache \
                supervisor \
                file \
                make \
    && pecl81 channel-update pecl.php.net \
    && pecl81 install -n mcrypt \
    && mkdir -p /var/www \
    && mv /root/supervisord.conf /etc/supervisord.conf \
    && mv /root/php.ini /etc/php81/php.ini \
    && mv /root/php-fpm.conf /etc/php81/php-fpm.conf \
    && mv /root/www.conf /etc/php81/php-fpm.d/www.conf \
    && rm -Rf /var/www/* \
    && mv /root/info.php /var/www/index.php \
    && ln -sf /dev/stderr /var/log/php81/error.log \
    && ln -sf /dev/stderr /var/log/php81/www.error.log \
    && ln -sf /dev/stdout /var/log/php81/www.access.log \
    && ln -sf /dev/stderr /usr/local/apache2/logs/error.log \
    && ln -sf /dev/stdout /usr/local/apache2/logs/access.log \
    && apk add --update --no-cache ssmtp \
    && echo "hostname=localhost.localdomain" > /etc/ssmtp/ssmtp.conf \
    && echo "root=postmaster" >> /etc/ssmtp/ssmtp.conf \
    && echo "mailhub=smtp.example.com:25" >> /etc/ssmtp/ssmtp.conf \
    && echo "sendmail_path=sendmail -i -t" >> /etc/php81/conf.d/php-sendmail.ini \
    && echo "localhost localhost.localdomain" >> /etc/hosts \
    && echo "nginx:webmaster@localhost.localdomain" >> /etc/ssmtp/revaliases \
    && echo "root:webmaster@localhost.localdomain" >> /etc/ssmtp/revaliases \
    && echo "disable_functions = system,popen,dl,passthru,shell_exec" >> /etc/php81/php.ini \
    && echo "extension=mcrypt.so" >> /etc/php81/php.ini

WORKDIR /var/www

EXPOSE 9000 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# Metadata params
ARG BUILD_DATE
ARG VERSION
ARG VCS_URL="https://github.com/scolagreco/alpine_apache_php-fpm.git"
ARG VCS_REF
ARG AUTHORS="Stefano Colagreco <stefano@colagreco.it>"
ARG VENDOR

# Metadata
LABEL org.opencontainers.image.authors=$AUTHORS \
      org.opencontainers.image.vendor=$VENDOR \
      org.opencontainers.image.title="alpine_apache_php-fpm" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.source=$VCS_URL \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.description="Docker Image di Alpine con installato Apache 2.4 e PHP 8.1 (php81-fpm)"

