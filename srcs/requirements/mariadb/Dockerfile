FROM debian:12.0

RUN apt-get update && \
	apt-get install -y \
	mariadb-server && \
	rm -rf /var/lib/apt/lists/*

COPY ./conf/my.cnf /etc/mysql/my.cnf

COPY ./tools/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir -p /run/mysqld
RUN chown mysql:mysql /run/mysqld
RUN chmod 755 /run/mysqld

#ビルド時の環境変数を定義
# ARG MYSQL_USER

# RUN groupadd -r ${MYSQL_USER}
# RUN	useradd -r -g ${MYSQL_USER} ${MYSQL_USER}
# USER ${MYSQL_USER}

EXPOSE 3306

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
