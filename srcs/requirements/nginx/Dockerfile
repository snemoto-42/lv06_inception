FROM debian:12.0

RUN apt-get update \
	&& apt-get install -y nginx openssl \
	&& rm -rf /var/lib/apt/lists/*

COPY ./tools/conf /etc/nginx/conf

RUN mkdir -p /etc/nginx/ssl

RUN openssl req \
	-x509 \
	-nodes \
	-days 365 \
	-newkey rsa:2048 \
	-subj "/CN=snemoto.42.fr" \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt

# 不要？
RUN mkdir -p /run/nginx
WORKDIR /var/www/html

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
