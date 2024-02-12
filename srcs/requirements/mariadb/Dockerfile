FROM debian:12.0

ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
ENV MYSQL_DATABASE=${MYSQL_DATABASE}
ENV MYSQL_USER=${MYSQL_USER}
ENV MYSQL_PASSWORD=${MYSQL_PASSWORD}

RUN apt-get update \
	&& apt-get install -y mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

COPY ./tools/my.cnf /etc/mysql/my.cnf

VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

ENTRYPOINT [ "entrypoint.sh" ]

COPY ./tools/entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

CMD [ "mysqld" ]
