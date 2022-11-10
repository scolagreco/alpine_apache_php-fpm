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
    && apk add --update --no-cache \
                php8 \
                php8-fpm \
                php8-mysqli \
                php8-json \
                php8-openssl \
                php8-curl \
                php8-zlib \
                php8-xml \
                php8-phar \
                php8-intl \
                php8-dom \
                php8-xmlreader \
                php8-ctype \
                php8-mbstring \
                php8-gd \
                php8-iconv \
                php8-posix \
    && apk add --update --no-cache \
                php8-intl \
                php8-pdo_mysql \
                php8-pspell \
                php8-fileinfo \
                php8-opcache \
                php8-ldap \
                php8-pdo_pgsql \
                php8-pgsql \
                php8-pdo_odbc \
                php8-zip \
                php8-pecl-mcrypt \
                php8-soap \
                php8-apcu \
                php8-session \
                php8-simplexml \
                php8-pecl-ssh2 \
    && apk add --update --no-cache \
                php8-tokenizer \
                php8-ftp \
                php8-gmp \
                php8-pdo_sqlite \
                php8-sqlite3 \
                php8-xmlwriter \
                php8-xsl \
                php8-pecl-imagick \
                php8-pecl-imagick-dev \
    && apk add --update --no-cache \
                php8-bz2 \
                php8-pecl-memcached \
                php8-redis \
                php8-imap \
                php8-exif \
                php8-pcntl \
    && apk add --update --no-cache \
                supervisor \
                file \
                make \
    && mkdir -p /var/www \
    && mv /root/supervisord.conf /etc/supervisord.conf \
    && mv /root/php.ini /etc/php8/php.ini \
    && mv /root/php-fpm.conf /etc/php8/php-fpm.conf \
    && mv /root/www.conf /etc/php8/php-fpm.d/www.conf \
    && rm -Rf /var/www/* \
    && mv /root/info.php /var/www/index.php \
    && ln -sf /dev/stderr /var/log/php8/error.log \
    && ln -sf /dev/stderr /var/log/php8/www.error.log \
    && ln -sf /dev/stdout /var/log/php8/www.access.log \
    && ln -sf /dev/stderr /usr/local/apache2/logs/error.log \
    && ln -sf /dev/stdout /usr/local/apache2/logs/access.log \
    && apk add --update --no-cache ssmtp \
    && echo "hostname=localhost.localdomain" > /etc/ssmtp/ssmtp.conf \
    && echo "root=postmaster" >> /etc/ssmtp/ssmtp.conf \
    && echo "mailhub=smtp.example.com:25" >> /etc/ssmtp/ssmtp.conf \
    && echo "sendmail_path=sendmail -i -t" >> /etc/php8/conf.d/php-sendmail.ini \
    && echo "localhost localhost.localdomain" >> /etc/hosts \
    && echo "nginx:webmaster@localhost.localdomain" >> /etc/ssmtp/revaliases \
    && echo "root:webmaster@localhost.localdomain" >> /etc/ssmtp/revaliases

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
      org.opencontainers.image.description="Docker Image di Alpine con installato Apache 2.4 e PHP 8.0 (php8-fpm)"

