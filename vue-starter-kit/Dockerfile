# Stage 1: Build frontend assets
FROM node:20 as node_assets

WORKDIR /app

# Copy only package.json and package-lock.json to leverage Docker cache
COPY package*.json ./
RUN npm install

# Copy the rest of the frontend files
COPY resources/ ./resources/
COPY tailwind.config.js vite.config.ts tsconfig.json ./

# Build the assets
RUN npm run build

# Stage 2: Setup PHP environment
FROM php:8.3-fpm

WORKDIR /var/www/html

# Install system dependencies for Laravel (gd, pdo, zip, etc.)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_pgsql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy application files from the current directory into the container
COPY . .

# Copy built assets from the node_assets stage
COPY --from=node_assets /app/public/build ./public/build

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
