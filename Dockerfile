FROM php:7.4-alpine

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php

COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache \
    zip \
    git \
    libpng \
    libpng-dev \
    libzip-dev \
    php-gd \
    php-zip

RUN docker-php-ext-install gd zip
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]