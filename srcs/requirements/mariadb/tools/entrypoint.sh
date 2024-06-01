#!/bin/bash
set -e

# for debug
# echo "checking files at /var/lib/mysql/mysql"
# ls -la /var/lib/mysql/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Setting up MariaDB for the first time."

	mariadb_install_db
	pid="$!"

	mysql -uroot -e "CREATE USER ${WORDPRESS_DB_NAME} \
		IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}';"
	mysql -uroot -e "GRANT ALL PRIVILEGES \
		ON ${WORDPRESS_DB_NAME}.* \
		TO '${WORDPRESS_DB_USER}'@'%' \
		IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}';"
	mysql -uroot -e "FLUSH PRIVILEGES;"

	if ! kill -s TERM "$pid" || ! wait "$pid"; then
		echo >$2 'MariaDB init process failed.'
		exit 1
	fi

	echo "MariaDB setup completed."
fi

echo "Starting MariaDB server..."
exec "$@"
