FROM debian:12.0

RUN apt-get update \
	&& apt-get install -y \
	php-fpm \
	php-mysql \
	wordpress \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^listen = \/run\/php\/php[0-9\.]*-fpm.sock/listen = 9000' /etc/php/7.4/fpm/pool.d/www.conf

COPY ./srcs/wordpress/tools/wp-config.php /var/www/html/wordpress/

EXPOSE 9000

CMD [ "php7.4-fpm", "-F" ]
