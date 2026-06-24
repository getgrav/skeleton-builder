FROM php:8.3-alpine
LABEL maintainer="Team Grav <devs@getgrav.org>"

# Composer (copied from the official image rather than the web installer)
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Runtime libraries plus the build deps needed to compile gd and zip.
# The build deps are dropped again at the end to keep the image small.
RUN apk add --no-cache \
        git \
        zip \
        unzip \
        curl \
        libpng \
        libjpeg-turbo \
        libwebp \
        freetype \
        libzip \
    && apk add --no-cache --virtual .build-deps \
        libpng-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
        freetype-dev \
        libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j"$(nproc)" gd zip \
    && apk del .build-deps

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
