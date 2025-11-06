# Image de base PHP
FROM php:8.1

# Définir le répertoire de travail
WORKDIR /project

COPY app/entrypoint.sh /project/entrypoint.sh
RUN chmod +x /project/entrypoint.sh

# Copier le code source dans le conteneur
COPY app .


RUN apt-get update && apt-get install -y \
        curl \
        zip \
        libpq-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype-dev \
        && curl -sS https://getcomposer.org/installer | php \
        && mv composer.phar /usr/local/bin/composer \
        && docker-php-ext-install bcmath pgsql pdo pdo_pgsql 



# Exposer le port utilisé 
EXPOSE 8000

#RUN www  \

RUN adduser www \

&& usermod -aG www www

# Generate key

RUN chown -R www:www /project \
	&& chmod -R 775 /project/storage

RUN  composer install  && php artisan key:gen



USER www

# Démarrer le serveur Laravel
ENTRYPOINT ["php", "artisan", "serve", "--host=0.0.0.0"]
#ENTRYPOINT ["sleep", "10000000000"]





