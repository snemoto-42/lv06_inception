FROM debian:12.0

RUN apt-get update && \
	apt-get install -y \
		curl \
		php-fpm \
		php-mysql && \
	rm -rf /var/lib/apt/lists/*

RUN curl -0 https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin

RUN sed -i 's/listen = .*/listen = 0.0.0.0:9000' \
		/etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i "s/^listen.allowed_clients/;listen.allowed_clients/" \
		/etc/php/7.4/fpm/pool.d/www.conf

COPY ./tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

EXPOSE 9000

CMD [ "php7.4-fpm", "-F" ]
