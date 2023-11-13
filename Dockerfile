FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libonig-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install mbstring exif pcntl bcmath mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN git clone https://github.com/ProtasovM/softEng.git /var/www/app
RUN chown -R www-data:www-data /var/www/app

# Set working directory
WORKDIR /var/www/app

COPY ./app/run.sh /tmp/run.sh
RUN chmod +x /tmp/run.sh

COPY ./app/wait-for-it.sh /tmp/wait-for-it.sh
RUN chmod +x /tmp/wait-for-it.sh

USER www-data

RUN composer install
