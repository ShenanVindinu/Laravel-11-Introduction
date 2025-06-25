# Use official PHP image with PHP-FPM
FROM php:8.2-fpm

# Set working directory inside the container
WORKDIR /var/www/html

# Install system dependencies and PHP extensions needed by Laravel
RUN apt-get update && apt-get install -y \
    git zip unzip libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Copy project files to the container
COPY . .

# Install Composer (PHP package manager)
/usr/bin/php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"/
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm composer-setup.php

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set folder permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Generate app key
RUN php artisan key:generate

# Expose port 9000 and start PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]
