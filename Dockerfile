# Build stage for PHP dependencies
FROM composer:latest AS composer

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

# Build stage for Node.js dependencies
FROM node:20 AS node

WORKDIR /app

COPY package.json package-lock.json ./
COPY vite.config.js ./
COPY resources/ ./resources/

RUN npm ci && npm run build

# Production stage
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libsqlite3-dev \
    zip \
    unzip \
    && apt-get clean && rm -rf /var/cache/apt/*

# Install PHP extensions
RUN docker-php-ext-install pdo_sqlite mbstring exif pcntl bcmath gd

# Copy PHP dependencies from composer stage
COPY --from=composer /app/vendor/ ./vendor/

# Copy built assets from node stage
COPY --from=node /app/public/build/ ./public/build/

# Copy application files
COPY . .

# Copy .env.example to .env
RUN cp .env.example .env

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Generate optimized autoload files
RUN composer dump-autoload --optimize --no-dev

# Generate application key
RUN php artisan key:generate

# Cache configuration
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# Create SQLite database
RUN touch database/database.sqlite && \
    chown -R www-data:www-data database/database.sqlite && \
    php artisan migrate --force

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM server
CMD ["php-fpm"]
