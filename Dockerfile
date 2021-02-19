FROM php:7.4-alpine
RUN apk add --no-cache zip \
    chmod +x /entrypoint.sh

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_HOME=/tmp \
    COMPOSER_PATH=/usr/bin/composer

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY entrypoint.sh /entrypoint.sh

RUN curl -L https://getgrav.org/download/core/grav/$INPUT_VERSION > /grav.zip

ENTRYPOINT ['/entrypoint.sh']