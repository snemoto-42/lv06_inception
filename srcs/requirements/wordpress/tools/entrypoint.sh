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
# echo "checking files at ${HTML_PATH}"
# pwd
# ls -al

# sed -i "s/listen = .*/listen = 0.0.0.0:9000/" /etc/php/8.2/fpm/pool.d/www.conf
# sed -i "s/^listen.allowed_clients/;listen.allowed_clients/" /etc/php/8.2/fpm/pool.d/www.conf

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
		# --role=author
	# wp --allow-root --path="${HTML_PATH}" option update comment_registration 1
fi

echo "finish setting up for Wordpress."

# exec "$@"
# exec php-fpm -v
exec php-fpm8.2 --nodaemonize
