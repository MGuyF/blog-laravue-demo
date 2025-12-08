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

# Set proper permissions (run as root, then PHP will handle it)
RUN chmod -R 777 /app/storage /app/bootstrap/cache /app/database

# Clear any cached config that might interfere
RUN rm -rf /app/bootstrap/cache/*.php

# Generate application key
RUN php artisan key:generate --force

# Run migrations
RUN php artisan migrate --force || echo "Migration failed but continuing..."

# Don't cache config in build (do it at runtime if needed)
# This prevents cache issues with environment variables

# Create a startup script
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Starting application..."\n\
echo "Current directory: $(pwd)"\n\
echo "Files in /app:"\n\
ls -la /app\n\
echo "Database file exists:"\n\
ls -la /app/database/database.sqlite || echo "Database not found!"\n\
echo "Storage permissions:"\n\
ls -la /app/storage\n\
echo "Environment variables:"\n\
env | grep APP_ || true\n\
echo "Running migrations..."\n\
php artisan migrate --force || echo "Migration warning"\n\
echo "Starting server..."\n\
php artisan serve --host=0.0.0.0 --port=10000' > /start.sh \
    && chmod +x /start.sh

# Expose port
EXPOSE 10000

# Use the startup script
CMD ["/bin/bash", "/start.sh"]