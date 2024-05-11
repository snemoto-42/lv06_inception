FROM debian:12.0

# ビルド時の環境変数を定義
ARG SSL_PATH

RUN apt-get update && \
	apt-get install -y \
		nginx \
		openssl && \
	rm -rf /var/lib/apt/lists/*

COPY ./conf/my.conf /etc/nginx/conf

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
