# Use Alpine Linux as base image
FROM alpine:latest

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install Nginx and PHP 8.1
RUN apk --no-cache add nginx php8 php8-fpm php8-opcache php8-mysqli php8-pdo php8-pdo_mysql php8-json php8-openssl php8-curl php8-zlib php8-xml php8-phar php8-intl php8-dom php8-xmlreader php8-ctype php8-session php8-gd php8-tokenizer php8-fileinfo php8-iconv php8-simplexml

# Configure Nginx
COPY .docker/nginx.conf /etc/nginx/nginx.conf
COPY .docker/nginx-laravel.conf /etc/nginx/conf.d/default.conf

# Set up PHP-FPM
RUN mkdir -p /run/php && \
    sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php8/php.ini

# Expose ports 80 and 443
EXPOSE 80
EXPOSE 443

# Set the default command to start Nginx and PHP-FPM
CMD ["nginx", "-g", "daemon off;"]
