#!/bin/sh

cd /var/www/forHighSmith
if [ -e /tmp/booted ]; then
   php-fpm
else
    php artisan migrate --seed \
      && php artisan db:seed -vv --class "Database\Seeders\BankTableSeeder" \
      && php artisan db:seed -vv --class "Database\Seeders\ApplicationTableSeeder" \
      && touch /tmp/booted \
      && php-fpm
fi