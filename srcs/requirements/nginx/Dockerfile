FROM nginx:latest

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY certs/server.crt /etc/nginx/server.crt
COPY certs/server.key /etc/nginx/server.key

EXPOSE 443
