FROM debian:12.0

# ビルド時の環境変数を定義
ARG WORDPRESS_DB_USER

RUN apt-get update && \
	apt-get install -y \
		mariadb-server && \
	rm -rf /var/lib/apt/lists/*

COPY ./conf/my.cnf /etc/mysql/my.cnf

COPY ./tools/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN groupadd -r ${WORDPRESS_DB_USER}
RUN	useradd -r -g ${WORDPRESS_DB_USER} ${WORDPRESS_DB_USER}
USER ${WORDPRESS_DB_USER}

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

EXPOSE 3306

CMD [ "mysqld_safe" ]
