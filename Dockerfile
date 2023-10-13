FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libpq-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install mbstring exif pcntl bcmath pdo_pgsql

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN git clone https://github.com/ProtasovM/forHighSmith.git /var/www/forHighSmith
RUN chown -R www-data:www-data /var/www/forHighSmith

# Set working directory
WORKDIR /var/www/forHighSmith

COPY ./app/run.sh /tmp/run.sh
RUN chmod +x /tmp/run.sh

COPY ./app/wait-for-it.sh /tmp/wait-for-it.sh
RUN chmod +x /tmp/wait-for-it.sh

USER www-data

RUN composer install
