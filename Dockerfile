FROM alpine:latest

WORKDIR /var/www/html/

# Essentials
RUN echo "UTC" > /etc/timezone
# RUN apk add --no-cache zip unzip curl nginx supervisor git nodejs npm php-bcmath libpng-dev libxml2-dev
RUN apk add --no-cache zip unzip curl nginx supervisor

# Installing bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Installing PHP
RUN apk add --no-cache php83 \
    php83-common \
    php83-fpm \
    php83-pdo \
    php83-opcache \
    php83-zip \
    php83-phar \
    php83-iconv \
    php83-cli \
    php83-curl \
    php83-openssl \
    php83-mbstring \
    php83-tokenizer \
    php83-fileinfo \
    php83-json \
    php83-xml \
    php83-xmlwriter \
    php83-simplexml \
    php83-dom \
    php83-pdo_mysql \
    php83-tokenizer \
    php83-pecl-redis

RUN ln -s /usr/bin/php83 /usr/bin/php

# Installing composer
# RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
# RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
# RUN rm -rf composer-setup.php

# Configure supervisor
# RUN mkdir -p /etc/supervisor.d/
# COPY .docker/supervisord.ini /etc/supervisor.d/supervisord.ini

# Configure PHP
RUN mkdir -p /run/php/
RUN touch /run/php/php8.3-fpm.pid

COPY .docker/php-fpm.conf /etc/php83/php-fpm.conf
COPY .docker/php.ini /etc/php83/php.ini

# Configure nginx
COPY .docker/nginx.conf /etc/nginx/
COPY .docker/nginx-laravel.conf /etc/nginx/modules/

RUN mkdir -p /run/nginx/
RUN touch /run/nginx/nginx.pid

# Create Supervisor log and PID directories
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/run/supervisor
RUN chown -R nobody:nobody /var/log/supervisor /var/run/supervisor

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Building process
COPY system/ .
# RUN mkdir -p /var/ops
# COPY ops/ /var/ops

# CREATING THE FOLLOWING DIRECTORIES BECAUSE LARAVEL COMPLAINS ABOUT A INVALID CACHE PATH IF THEY DONT EXIST
RUN mkdir -p ./storage/framework/cache
RUN mkdir -p ./storage/framework/sessions
RUN mkdir -p ./storage/framework/testing
RUN mkdir -p ./storage/framework/views
RUN mkdir -p ./storage/logs

# RUN npm install -g yarn
# RUN yarn install

# RUN composer install --no-dev
RUN chown -R nobody:nobody /var/www/html/storage

EXPOSE 80
# CMD ["supervisord", "-c", "/etc/supervisor.d/supervisord.ini"]