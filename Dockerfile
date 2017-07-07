FROM php:7.1-fpm

RUN apt update && apt upgrade -y && apt install -y \
  libicu-dev \
  zlib1g-dev \
  libmemcached-dev \
  libcurl4-openssl-dev \
  libmcrypt-dev \
  libpng-dev \
  libxml2-dev \
  libpcre3-dev \
&& docker-php-ext-install -j$(nproc) intl dom zip json mbstring gd \
iconv opcache pdo_mysql curl mcrypt simplexml xml \
&& pecl install xdebug \
&& docker-php-ext-enable xdebug

# Install Memcached for php 7
RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p /usr/src/php/ext/memcached \
    && tar -C /usr/src/php/ext/memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && docker-php-ext-configure memcached \
    && docker-php-ext-install memcached \
    && rm /tmp/memcached.tar.gz

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/3.1.2.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-3.1.2 /usr/src/php/ext/redis \
    && docker-php-ext-install redis

RUN echo "xdebug.remote_enable = 1" | tee -a $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini
RUN echo "memory_limit = \"-1\"" | tee -a $PHP_INI_DIR/conf.d/memory-limit.ini

COPY date.ini $PHP_INI_DIR/conf.d/date.ini
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
WORKDIR /var/www/html
CMD ["php-fpm"]
