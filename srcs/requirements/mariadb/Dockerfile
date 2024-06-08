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

EXPOSE 3306

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
