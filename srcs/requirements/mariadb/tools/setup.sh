#!/bin/bash
set -e

# Ensure MariaDB socket directory exists
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld


# Start MariaDB in the background for setup
mysqld --skip-networking &
sleep 5

# Create the database and user if they don't exist
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Debug: Show databases and users
echo "Databases:"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SHOW DATABASES;"
echo "Users:"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SELECT User, Host FROM mysql.user;"


# Kill background mysqld
kill %1

# Start MariaDB normally (foreground)
exec mysqld_safe
