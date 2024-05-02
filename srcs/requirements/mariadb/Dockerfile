FROM debian:12.0

RUN apt-get update && \
	apt-get install -y \
		mariadb-server && \
	rm -rf /var/lib/apt/lists/*

COPY ./conf/my.cnf /etc/mysql/my.cnf

COPY ./tools/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN groupadd -r mysqluser && \
	useradd -r -g mysqluser mysqluser
USER mysqluser

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

EXPOSE 3306

CMD [ "mysqld" ]
