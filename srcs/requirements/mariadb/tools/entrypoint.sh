#!/bin/bash
set -e

# for debug
# echo "checking files at /var/lib/mysql/mysql"
# ls -la /var/run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_note "Setting up MariaDB."
	mysql_install_db
	# pid="$!"

	# if ! kill -s TERM "$pid" || ! wait "$pid"; then
	# 	echo >$2 'MariaDB init process failed.'
	# 	exit 1
	# fi

	# -e コマンドラインから直接クエリを実行して、結果を表示する
	mysql -uroot -e "CREATE DATABASE '${MYSQL_DATABASE}';"

	mysql -uroot -e "CREATE USER ${MYSQL_USER} \
		IDENTIFIED BY '${MYSQL_PASSWORD}';"

	mysql -uroot -e "GRANT ALL PRIVILEGES \
		ON ${MYSQL_DATABASE}.* \
		TO '${MYSQL_USER}'@'%' \
		IDENTIFIED BY '${MYSQL_PASSWORD}';"

	mysql -uroot -e "FLUSH PRIVILEGES;"

	mysql_note "MariaDB setup completed."

fi

# mysqld --skip-networking --socket="/run/mysqld/mysqld.sock"

# until mysqladmin ping --silent; do
# 	mysql_note "Waiting for MariaDB to start ..."
# 	sleep 5
# done

echo "Starting MariaDB server..."
# exec "$@"

mysqld --console
