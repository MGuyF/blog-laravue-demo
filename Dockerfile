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
RUN composer install --no-dev --optimize-autoloader
RUN npm install

# Build assets
RUN npm run build

# Create the SQLite database file and run migrations
RUN touch database/database.sqlite
RUN php artisan migrate --force

# Expose port and define start command
EXPOSE 10000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]