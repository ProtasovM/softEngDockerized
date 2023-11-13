#!/bin/sh

cd /var/www/app
if [ -e /tmp/booted ]; then
   php-fpm
else
    php artisan migrate --seed \
      && php artisan passport:client --password --name test --provider users \
      && php artisan passport:install \
      && touch /tmp/booted \
      && php-fpm
fi