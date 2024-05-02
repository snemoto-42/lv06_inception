FROM debian:12.0

RUN apt-get update && \
	apt-get install -y \
		nginx \
		openssl && \
	rm -rf /var/lib/apt/lists/*

COPY ./tools/conf /etc/nginx/conf

RUN mkdir -p ${SSL_PATH}
RUN openssl req \
	-x509 \
	-nodes \
	-days 365 \
	-newkey rsa:2048 \
	-subj "/CN=snemoto.42.fr" \
	-keyout ${SSL_PATH}/nginx.key \
	-out ${SSL_PATH}/nginx.crt

# 不要？
# RUN mkdir -p /run/nginx
# WORKDIR /var/www/html

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
