#!/bin/bash

set -e

# `until mysqladmin ping -uroot --silent; do
# 	echo "Waiting for MariaDB to start ..."
# 	sleep 5
# done

# echo "MariaDB is starting..."

# ls -al /var/www/html

if [ ! -f wp-config.php ]; then
	wp --allow-root --path=/var/www/html core config \
		--dbhost="${WORDPRESS_DB_HOST}" \
		--dbname="${WORDPRESS_DB_NAME}" \
		--dbuser="${WORDPRESS_DB_USER}" \
		--dbpass="${WORDPRESS_DB_PASSWORD}"
fi

if ! $(wp --allow-root core is-innstalled); then
	wp --allow-root --path=/var/www/html core install \
		--url="${WORDPRESS_URL}" \
		--title="${WORDPRESS_TITLE}" \
		--admin_user="${WORDPRESS_ADMIN_USER}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}"
	wp --allow-root --path=/var/www/html user create \
		--user="${WORDPRESS_SUBSCRIBER_USER}" \
		--user_pass="${WORDPRESS_SUBSCRIBER_PASSWORD}" \
		--user_email="${WORDPRESS_SUBSCRIBER_EMAIL}" \
		--role=subscriber
	wp --allow-root --path=/var/www/html option update comment_registration 1
fi
