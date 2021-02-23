FROM php:7.4-alpine

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php

COPY entrypoint.sh /entrypoint.sh

RUN apk add --quiet -no-cache \
    zip \
    git \
    libpng \
    libpng-dev \
    libzip-dev \
    php-gd \
    php-zip

RUN set -x
RUN docker-php-ext-install gd zip > /dev/null
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]