FROM php:8.2-fpm

# Install dependencies
RUN apt update && apt install -y zip unzip curl git libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd opcache \
    && pecl install redis && docker-php-ext-enable redis

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy app files
COPY . /var/www
WORKDIR /var/www

# Install composer dependencies only
RUN composer install --no-dev --optimize-autoloader

# Set correct permissions for Laravel directories
RUN chown -R www-data:www-data /var/www/storage \
    && chmod -R 775 /var/www/storage \
    && chown -R www-data:www-data /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/bootstrap/cache

EXPOSE 9000
