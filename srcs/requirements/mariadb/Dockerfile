FROM debian:12.0

RUN apt-get update \
	&& apt-get install -y mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

COPY ./tools/my.cnf /etc/mysql/my.cnf

COPY ./tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

EXPOSE 3306

CMD [ "mysqld" ]
