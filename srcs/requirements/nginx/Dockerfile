FROM nginx:latest

COPY tools/conf /etc/nginx/conf

COPY certs/server.crt /etc/nginx/server.crt
COPY certs/server.key /etc/nginx/server.key

EXPOSE 443
