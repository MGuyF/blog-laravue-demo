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

# Create .env file from .env.example if it doesn't exist
RUN if [ -f .env.example ]; then cp .env.example .env; else \
    echo "APP_NAME=Laravel\n\
APP_ENV=production\n\
APP_KEY=\n\
APP_DEBUG=false\n\
APP_URL=http://localhost\n\
LOG_CHANNEL=stderr\n\
LOG_LEVEL=debug\n\
DB_CONNECTION=sqlite\n\
DB_DATABASE=/app/database/database.sqlite\n\
CACHE_DRIVER=file\n\
SESSION_DRIVER=file\n\
QUEUE_CONNECTION=sync" > .env; fi

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
RUN chmod -R 777 /app/storage /app/bootstrap/cache /app/database

# Clear any cached config that might interfere
RUN rm -rf /app/bootstrap/cache/*.php

# Generate application key
RUN php artisan key:generate --force

# Run migrations
RUN php artisan migrate --force || echo "Migration failed but continuing..."

# Create a startup script that respects environment variables from Render
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Update .env with runtime environment variables from Render\n\
if [ ! -z "$APP_KEY" ]; then\n\
    sed -i "s|APP_KEY=.*|APP_KEY=$APP_KEY|g" /app/.env\n\
fi\n\
if [ ! -z "$APP_URL" ]; then\n\
    sed -i "s|APP_URL=.*|APP_URL=$APP_URL|g" /app/.env\n\
fi\n\
if [ ! -z "$APP_DEBUG" ]; then\n\
    sed -i "s|APP_DEBUG=.*|APP_DEBUG=$APP_DEBUG|g" /app/.env\n\
fi\n\
\n\
echo "=== Application Starting ==="\n\
echo "Current directory: $(pwd)"\n\
echo "Database file:"\n\
ls -la /app/database/database.sqlite 2>/dev/null || echo "Database file not found!"\n\
echo "APP_KEY: ${APP_KEY:0:20}..." \n\
echo "APP_URL: $APP_URL"\n\
echo "APP_DEBUG: $APP_DEBUG"\n\
echo "=========================="\n\
\n\
# Run migrations at startup\n\
php artisan migrate --force || echo "Migration warning"\n\
\n\
# Clear and cache config\n\
php artisan config:clear\n\
php artisan config:cache\n\
\n\
# Start the server\n\
echo "Starting Laravel server on 0.0.0.0:10000..."\n\
php artisan serve --host=0.0.0.0 --port=10000' > /start.sh \
    && chmod +x /start.sh

# Expose port
EXPOSE 10000

# Use the startup script
CMD ["/bin/bash", "/start.sh"]