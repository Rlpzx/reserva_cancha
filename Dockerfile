FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev mariadb-client \
    && docker-php-ext-install pdo_mysql mbstring gd xml

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Permisos de storage y cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Exponer puerto
EXPOSE 80

# Comando de inicio
CMD php artisan migrate --force && php artisan serve --host 0.0.0.0 --port 80
