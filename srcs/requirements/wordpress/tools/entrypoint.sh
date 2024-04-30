#!/bin/bash

# ----define----
wait_for_mysql()
{
	until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
		echo "Waiting for MariaDB to start ..."
		sleep 1
	done
	echo "MariaDB is starting..."
}

# ----execute_----
set -e

wait_for_mysql

if [ ! -f wp-config.php ]; then
	wp --allow-root core config \
		--dbhost="${WORDPRESS_DB_HOST}" \
		--dbname="${WORDPRESS_DB_NAME}" \
		--dbuser="${WORDPRESS_DB_USER}" \
		--dbpass="${WORDPRESS_DB_PASSWORD}"
fi

if ! $(wp --allow-root core is-innstalled); then
	wp --allow-root core install \
		--url="${WORDPRESS_URL}" \
		--title="Your WordPress Site" \
		--admin_user="${WORDPRESS_ADMIN_USER}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}"
	wp --allow-root user create \
		"${WORDPRESS_SUBSCRIBER_USER}" user@example.com \
		--user_pass="${WORDPRESS_SUBSCRIBER_PASSWORD}" \
		--role=subscriber
	wp --allow-root option update comment_registration 1
fi
