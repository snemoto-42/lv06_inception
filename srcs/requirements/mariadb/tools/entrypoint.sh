#!/bin/bash
set -e

# for debug
# echo "checking files at /var/lib/mysql/mysql"
# ls -la /var/run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_note "Setting up MariaDB."
	mysql_install_db
	# pid="$!"
fi

# バックグラウンドでサーバーを起動
mysqld --skip-networking --socket="/run/mysqld/mysqld.sock" &
pid="$!"

until mysqladmin ping --silent; do
	echo "Waiting for MariaDB to start ..."
	sleep 5
done

# -e コマンドラインから直接クエリを実行して、結果を表示する
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

mysql -uroot -e "CREATE USER IF NOT EXISTS ${MYSQL_USER} \
	IDENTIFIED BY '${MYSQL_PASSWORD}';"

mysql -uroot -e "GRANT ALL PRIVILEGES \
	ON ${MYSQL_DATABASE}.* \
	TO '${MYSQL_USER}'@'%' \
	IDENTIFIED BY '${MYSQL_PASSWORD}';"

mysql -uroot -e "FLUSH PRIVILEGES;"

echo "MariaDB setup completed."

if ! kill -s TERM "$pid" || ! wait "$pid"; then
	echo >$2 'MariaDB init process failed.'
	exit 1
fi

echo "Starting MariaDB server..."

# exec "$@"
# exec mysqld --console
exec mysqld
