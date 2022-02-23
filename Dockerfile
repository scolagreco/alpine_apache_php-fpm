FROM scolagreco/docker-apache24:2.4.52

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
    && apk add --update --no-cache \
                php7 \
                php7-fpm \
                php7-mysqli \
                php7-json \
                php7-openssl \
                php7-curl \
                php7-zlib \
                php7-xml \
                php7-phar \
                php7-intl \
                php7-dom \
                php7-xmlreader \
                php7-ctype \
                php7-mbstring \
                php7-gd \
                php7-iconv \
                php7-posix \
    && apk add --update --no-cache \
                php7-intl \
                php7-pdo_mysql \
                php7-pspell \
                php7-fileinfo \
                php7-opcache \
                php7-ldap \
                php7-pdo_pgsql \
                php7-pgsql \
                php7-pdo_odbc \
                php7-zip \
                php7-mcrypt \
                php7-soap \
                php7-apcu \
                php7-session \
                php7-simplexml \
                php7-pecl-ssh2 \
    && apk add --update --no-cache \
                php7-tokenizer \
                php7-ftp \
                php7-gmp \
                php7-pdo_sqlite \
                php7-sqlite3 \
                php7-xmlwriter \
                php7-xsl \
                php7-pecl-imagick \
                php7-pecl-imagick-dev \
    && apk add --update --no-cache \
                php7-bz2 \
                php7-pecl-memcached \
                php7-redis \
                php7-imap \
                php7-exif \
                php7-pcntl \
    && apk add --update --no-cache \
                supervisor \
                file \
                make \
    && mkdir -p /var/www \
    && mv /root/supervisord.conf /etc/supervisord.conf \
    && mv /root/php.ini /etc/php7/php.ini \
    && mv /root/php-fpm.conf /etc/php7/php-fpm.conf \
    && mv /root/www.conf /etc/php7/php-fpm.d/www.conf \
    && rm -Rf /var/www/* \
    && mv /root/info.php /var/www/index.php \
    && ln -sf /dev/stderr /var/log/php7/error.log \
    && ln -sf /dev/stderr /var/log/php7/www.error.log \
    && ln -sf /dev/stdout /var/log/php7/www.access.log \
    && ln -sf /dev/stderr /usr/local/apache2/logs/error.log \
    && ln -sf /dev/stdout /usr/local/apache2/logs/access.log \
    && apk add --update --no-cache ssmtp \
    && echo "hostname=localhost.localdomain" > /etc/ssmtp/ssmtp.conf \
    && echo "root=postmaster" >> /etc/ssmtp/ssmtp.conf \
    && echo "mailhub=smtp.cnr.it:25" >> /etc/ssmtp/ssmtp.conf \
    && echo "sendmail_path=sendmail -i -t" >> /etc/php7/conf.d/php-sendmail.ini \
    && echo "localhost localhost.localdomain" >> /etc/hosts \
    && echo "nginx:webmaster@localhost.localdomain" >> /etc/ssmtp/revaliases \
    && echo "root:webmaster@localhost.localdomain" >> /etc/ssmtp/revaliases

WORKDIR /var/www

EXPOSE 9000 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# Metadata params
ARG BUILD_DATE
ARG VERSION
ARG VCS_URL
ARG VCS_REF

# Metadata
LABEL maintainer="Stefano Colagreco <stefano@colagreco.it>" \
        org.label-schema.name="Apache 2.4 e PHP 7.4 (php-fpm7)" \
        org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.version=$VERSION \
        org.label-schema.vcs-url=$VCS_URL \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.description="Docker Image di Alpine con installato Apache 2.4 e PHP 7.4 (php-fpm7)"

