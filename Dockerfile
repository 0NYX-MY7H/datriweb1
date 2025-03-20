FROM php:8.2-fpm

RUN apt update && apt install -y zip unzip curl git libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd opcache \
    && pecl install redis && docker-php-ext-enable redis

COPY . /var/www
WORKDIR /var/www

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader \
    && php artisan optimize:clear \
    && chown -R www-data:www-data /var/www/storage \
    && chmod -R 775 /var/www/storage

EXPOSE 9000
