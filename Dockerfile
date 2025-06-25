# Use official PHP image with PHP-FPM
FROM php:8.2-fpm

# Set working directory inside the container
WORKDIR /var/www/html

# Install system dependencies and PHP extensions needed by Laravel
RUN apt-get update && apt-get install -y \
    git zip unzip curl libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer (PHP package manager)
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm composer-setup.php

# Copy project files to the container
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set folder permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Create .env file from .env.example
RUN cp .env.example .env

# Generate app key
RUN php artisan key:generate

# Expose port 9000 and start PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]
