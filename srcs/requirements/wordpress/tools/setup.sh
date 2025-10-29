#!/bin/bash

set -e

mkdir -p /var/www/html
cd /var/www/html || exit 1

rm -rf ./*

if [ ! -x /usr/local/bin/wp ]; then
  curl -sSL -o wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
fi

wp core download --path=/var/www/html --allow-root

cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${WORDPRESS_DB_NAME:-db_name}/g" wp-config.php
sed -i "s/username_here/${WORDPRESS_DB_USER:-db_user}/g" wp-config.php
sed -i "s/password_here/${WORDPRESS_DB_PASSWORD:-db_pwd}/g" wp-config.php

if [ -n "${WORDPRESS_DB_HOST:-}" ]; then
  sed -i "s/'DB_HOST', 'localhost'/'DB_HOST', '${WORDPRESS_DB_HOST}'/g" wp-config.php || true
fi

wp core install --url="${WORDPRESS_URL:-http://${DOMAIN_NAME:-localhost}}" \
  --title="${WORDPRESS_SITE_TITLE:-WordPress}" \
  --admin_user="${WORDPRESS_ADMIN_USER:-admin}" \
  --admin_password="${WORDPRESS_ADMIN_PASSWORD:-admin}" \
  --admin_email="${WORDPRESS_ADMIN_EMAIL:-admin@localhost}" \
  --path=/var/www/html --skip-email --allow-root || true

if [ -n "${WORDPRESS_SECOND_USER:-}" ]; then
  wp user create "${WORDPRESS_SECOND_USER}" "${WORDPRESS_SECOND_EMAIL:-user@${DOMAIN_NAME:-localhost}}" \
    --user_pass="${WORDPRESS_SECOND_USER_PASSWORD:-$(date +%s | sha1sum | head -c 12)}" \
    --role="${WORDPRESS_SECOND_ROLE:-author}" --path=/var/www/html --allow-root || true
fi


if [ -f /etc/php/7.3/fpm/pool.d/www.conf ]; then
  sed -i 's|listen = /run/php/php7.3-fpm.sock|listen = 9000|g' /etc/php/7.3/fpm/pool.d/www.conf || true
fi
mkdir -p /run/php

if command -v wp >/dev/null 2>&1; then
  wp redis enable --path=/var/www/html --allow-root || true
fi

chown -R www-data:www-data /var/www/html || true

exec php-fpm7.4 -F
