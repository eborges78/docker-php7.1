#!/bin/sh

set -e

if [ "$1" = "php-fpm" ]; then
  root_path="/var/www/html"
  cache_path="${root_path}/var/cache"
  log_path="${root_path}/var/logs"

  chgrp -R www-data $cache_path $log_path
  chmod -R 775 $cache_path $log_path

  if [ -f "${cache_path}/.gitkeep" ]; then
    chmod 644 ${cache_path}/.gitkeep
  fi

  if [ -f "${log_path}/.gitkeep" ]; then
    chmod 644 ${log_path}/.gitkeep
  fi

  php-fpm
fi
