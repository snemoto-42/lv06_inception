FROM debian:12.0

RUN apt-get update && \
	apt-get install -y \
		# default-mysql-client \
		# ping \
		# lsof \
		curl \
		php8.2-fpm \
		php8.2-mysql && \
	rm -rf /var/lib/apt/lists/*

# -O フラグ：パスと同じファイル名でローカルに保存
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/php-fpm.conf /etc/php/8.2/fpm/php-fpm.conf
COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

EXPOSE 9000

COPY ./tools/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
