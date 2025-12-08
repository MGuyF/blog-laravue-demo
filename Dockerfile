# Stage 1: PHP Base with dependencies
FROM php:8.3-cli

WORKDIR /app

# Install system dependencies, PHP extensions, and Node.js
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libsqlite3-dev \
    libicu-dev \
    nodejs \
    npm \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pdo pdo_sqlite zip intl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the application files from the vue-starter-kit directory
COPY vue-starter-kit/ /app/

# Install dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Install npm dependencies
RUN npm install

# Build assets
RUN npm run build

# Create necessary directories with proper permissions
RUN mkdir -p /app/storage/framework/cache/data \
    /app/storage/framework/sessions \
    /app/storage/framework/views \
    /app/storage/logs \
    /app/bootstrap/cache \
    /app/database

# Create the SQLite database file
RUN touch /app/database/database.sqlite

# Set proper permissions
RUN chmod -R 775 /app/storage /app/bootstrap/cache /app/database \
    && chown -R www-data:www-data /app/storage /app/bootstrap/cache /app/database

# Generate application key if not set
RUN php artisan key:generate --force || true

# Run migrations
RUN php artisan migrate --force

# Cache configuration
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Expose port and define start command
EXPOSE 10000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]