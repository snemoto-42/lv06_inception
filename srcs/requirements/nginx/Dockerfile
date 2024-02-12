FROM debian:12.0

RUN apt-get update \
	&& apt-get install -y \
	nginx \
	openssl \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY ./certs/nginx-selfsigned.crt /etc/nginx/ssl/
COPY ./certs/nginx-selfsigned.key /etc/nginx/ssl/

RUN rm /etc/nginx/sites-enabled/default

COPY ./tools/my.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/my.conf /etc/nginx/sites-enabled/

VOLUME [ "/var/lib/nginx" ]

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
