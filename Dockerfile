FROM php:5.4-apache

RUN systemMods=" \
        apt-transport-https \
        git \
        gnupg \
        unzip \
    " \
    && apt-get update \
    && apt-get install -y $systemMods \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Composer
COPY --from=composer:1.5 /usr/bin/composer /usr/bin/composer
RUN composer --version

RUN a2enmod rewrite

RUN usermod -u 1000 www-data \
  && chown www-data:www-data /var/www 

WORKDIR /var/www/

CMD /usr/sbin/apache2ctl -D FOREGROUND
