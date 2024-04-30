#!/bin/bash

# ----define----
wait_for_mysql()
{
	until mysqladmin ping -h"${WORDPRESS_DB_HOST}" --silent; do
		echo "Waiting for MariaDB to start ..."
		sleep 1
	done
	echo "MariaDB is starting..."
}

# ----execute_----
set -e

if [ -d "/var/lib/mysql/mysql" ]; then
	echo "MariaDB is already set up"
else
	echo "Setting up MariaDB for the first time."

	mysql_install_db --user=mysql --datadir="/var/lib/mysql"

	mysqld_safe &
	pid="$!"

	wait_for_mysql

	mysql -uroot -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
	mysql -uroot -e "GRANT ALL \
		ON ${MYSQL_DATABASE}. * \
		TO '${MYSQL_USER}' \
		IDENTIFIED BY '${MYSQL_PASSWORD}';"
	mysql -uroot -e "FLUSH PRIVILEGES;"

	if ! kill -s TERM "$pid" || ! wait "$pid"; then
		echo >$2 'MariaDB init process failed.'
		exit 1
	fi

	echo "MariaDB setup completed."
fi

echo "Starting MariaDB server..."
exec "$@"
