FROM php:$PHP_VERSION-apache
RUN apt-get update && apt-get install -y libbz2-dev libenchant-2-dev \
libjpeg-dev libpng-dev libffi-dev libgd-dev libgmp-dev \
libc-client-dev libkrb5-dev libicu-dev libldap-dev libpspell-dev \
libsnmp-dev libxml2-dev libtidy-dev libxslt-dev libzip-dev unzip zip mariadb-client \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
RUN if [ $PHP_VERSION = '8.4' ]; then \
docker-php-ext-install bcmath bz2 calendar enchant exif ffi ftp gd gettext \
gmp intl ldap mysqli opcache pcntl pdo_mysql shmop snmp soap \
sockets sysvmsg sysvsem sysvshm tidy xsl zip; \
else \
docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
docker-php-ext-install bcmath bz2 calendar enchant exif ffi ftp gd gettext \
gmp imap intl ldap mysqli opcache pcntl pdo_mysql pspell shmop snmp soap \
sockets sysvmsg sysvsem sysvshm tidy xsl zip; \
fi
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN a2enmod rewrite
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
chmod a+x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN curl -Lfo /tmp/wordpress.zip https://wordpress.org/wordpress-$WORDPRESS_VERSION.zip \
&& unzip -q /tmp/wordpress.zip -d /tmp && mv /tmp/wordpress/* /var/www/html \
&& rm /tmp/wordpress.zip && rmdir /tmp/wordpress
COPY wp-config.php /var/www/html
