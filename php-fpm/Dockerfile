FROM php:8.2-fpm

RUN docker-php-ext-install mysqli pdo pdo_mysql

COPY php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/html
