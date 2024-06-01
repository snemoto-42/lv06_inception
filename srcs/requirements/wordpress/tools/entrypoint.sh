#!/bin/bash
set -e

# until mysqladmin ping -h"${WORDPRESS_HOST}" --silent; do
# 	echo "Waiting for MariaDB to start ..."
# 	sleep 5
# done
# echo "MariaDB is starting..."

# for debug
# echo "checking files at /etc/php/*/fpm/pool.d/"
# ls -la /etc/php/*/fpm/pool.d/

# # for debug
# echo "checking files at var/www/html"
# pwd
# ls -al

sed -i "s/listen = .*/listen = 0.0.0.0:9000/" /etc/php/*/fpm/pool.d/www.conf
sed -i "s/^listen.allowed_clients/;listen.allowed_clients/" /etc/php/*/fpm/pool.d/www.conf

cd /var/www/html
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

if [ ! -f index.php ]; then
	wp --allow-root --path='/var/www/html' core download
fi

if [ ! -f wp-config.php ]; then
	echo "wp-config.php does not exist."
	wp --allow-root --path='/var/www/html' core config \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${MYSQL_PASSWORD}" \
		--dbhost="${WORDPRESS_HOST}"
	echo "wp-config.php created."
	ls -al /var/www/html
fi

if ! $(wp --allow-root core is-innstalled); then
	wp --allow-root --path='/var/www/html' core install \
		--url="${WORDPRESS_URL}" \
		--title="${WORDPRESS_TITLE}" \
		--admin_user="${WORDPRESS_ADMIN_USER}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}"
	wp --allow-root --path='/var/www/html' user create \
		--user="${WORDPRESS_SUBSCRIBER_USER}" \
		--user_pass="${WORDPRESS_SUBSCRIBER_PASSWORD}" \
		--user_email="${WORDPRESS_SUBSCRIBER_EMAIL}" \
		--role=subscriber
	wp --allow-root --path='/var/www/html' option update comment_registration 1
fi
