#!/bin/bash
set -e

cd ${HTML_PATH}
chown -R www-data:www-data ${HTML_PATH}
chmod -R 755 ${HTML_PATH}

if [ ! -f index.php ]; then
	wp --allow-root --path="${HTML_PATH}" core download
fi

if [ ! -f wp-config.php ]; then
	echo "wp-config.php does not exist."
	wp --allow-root --path="${HTML_PATH}" core config \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${MYSQL_PASSWORD}" \
		--dbhost="${WORDPRESS_HOST}"
fi

if ! $(wp --allow-root core is-installed); then
	wp --allow-root --path="${HTML_PATH}" core install \
		--url="${DOMAIN_NAME}" \
		--title="${WORDPRESS_TITLE}" \
		--admin_user="${WORDPRESS_ADMIN_USER}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}"
	wp --allow-root --path="${HTML_PATH}" user create \
		${WORDPRESS_SUBSCRIBER_USER} \
		${WORDPRESS_SUBSCRIBER_EMAIL} \
		--user_pass="${WORDPRESS_SUBSCRIBER_PASSWORD}" \
		--role=subscriber
fi

echo "finish setting up for Wordpress."

# exec php-fpm -v
exec php-fpm8.2 --nodaemonize
