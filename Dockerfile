FROM php:8.2-fpm

# Install PHP extensions and dependencies
RUN apt update && apt install -y \
    git zip unzip curl libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd opcache \
    && pecl install redis && docker-php-ext-enable redis

# Install Composer globally with latest version
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set PHP recommended settings for Composer
RUN echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini"

# Copy application files
COPY . /var/www
WORKDIR /var/www

# Clear any previous installs
RUN rm -rf vendor composer.lock

# Install composer dependencies with proper permissions
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

# Set file permissions for Laravel directories
RUN chown -R www-data:www-data /var/www/storage \
    && chmod -R 775 /var/www/storage \
    && chown -R www-data:www-data /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/bootstrap/cache

EXPOSE 9000
