FROM debian:12.0

# ビルド時の環境変数を定義
ARG SSL_PATH
ARG DOMAIN_NAME

RUN apt-get update && \
	apt-get install -y \
		nginx \
		curl \
		# systemctl \
		# lsof \
		openssl && \
	rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf /etc/nginx/nginx.conf

RUN mkdir -p ${SSL_PATH}

RUN openssl req \
	-x509 \
	-nodes \
	-days 365 \
	-newkey rsa:2048 \
	-subj "/CN=${DOMAIN_NAME}" \
	-keyout ${SSL_PATH}/nginx.key \
	-out ${SSL_PATH}/nginx.crt

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
