#!/bin/bash
set -e

# Ensure MariaDB socket directory exists
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld


# Start MariaDB in the background for setup


# Read secrets if available
if [ -f /run/secrets/db_root_password ]; then
    MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
else
	MYSQL_ROOT_PASSWORD="example_root_pw"
fi
if [ -f /run/secrets/db_password ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_password)
else
	MYSQL_PASSWORD="wp_pass"
fi
# Admin user credentials from secrets if available
if [ -f /run/secrets/db_admin_user.txt ]; then
    MYSQL_ADMIN_USER=$(cat /run/secrets/db_admin_user.txt)
else
    MYSQL_ADMIN_USER="wpadminuser"
fi
if [ -f /run/secrets/db_admin_password.txt ]; then
    MYSQL_ADMIN_PASSWORD=$(cat /run/secrets/db_admin_password.txt)
else
    MYSQL_ADMIN_PASSWORD="wpadminpass"
fi

mysqld --skip-networking &
sleep 5


# Create the database and users if they don't exist
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
# Regular user
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
# Admin user
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_ADMIN_USER}'@'%';"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

# Debug: Show databases and users
echo "Databases:"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SHOW DATABASES;"
echo "Users:"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT User, Host FROM mysql.user;"

# Kill background mysqld
kill %1

# Start MariaDB normally (foreground)
exec mysqld_safe
