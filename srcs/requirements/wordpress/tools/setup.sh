#!/bin/bash
set -e

# Ensure correct permissions
chown -R www-data:www-data /var/www/html

# Generate wp-config.php only if it doesn't exist

# Read secrets if available
if [ -f /run/secrets/db_password ]; then
    WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password)
else
	WORDPRESS_DB_PASSWORD="wp_pass"
fi
if [ -f /run/secrets/credentials ]; then
    WORDPRESS_DB_USER=$(cat /run/secrets/credentials)
    if [[ "$WORDPRESS_DB_USER" == *admin* ]]; then
        echo "Error: The admin username must not contain 'admin'." >&2
        exit 1
    fi
else
	WORDPRESS_DB_USER="wp_user"
fi

if [ ! -f /var/www/html/wp-config.php ]; then
        echo "Generating wp-config.php..."
        cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
        sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" /var/www/html/wp-config.php
        sed -i "s/username_here/${WORDPRESS_DB_USER}/" /var/www/html/wp-config.php
        sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" /var/www/html/wp-config.php
        sed -i "s/localhost/${WORDPRESS_DB_HOST}/" /var/www/html/wp-config.php
        chown www-data:www-data /var/www/html/wp-config.php
        chmod 644 /var/www/html/wp-config.php
fi

exec php-fpm7.4 -F
