# デフォルトのターゲット
.DEFAULT_GOAL := help

# .envのパス
ENV_FILE := ./srcs/.env

# .envの読み込み、シェル環境にエクスポート
# docker-compose.yamlで環境変数を使用
# 各コンテナの環境変数はdocker-composeで読み込み
include $(ENV_FILE)
export

help :
	@echo "Available targets:"
	@echo " list		: ls images and containers"
	@echo " build		: Build images"
	@echo " up		: Start containers"
	@echo " up-d		: Start containers by detach mode"
	@echo " all		: Build images and Start containers"
	@echo " stop		: Stop containers"
	@echo " down		: Stop and remove containers"
	@echo " clean		: Clean up volume and networks"
	@echo " fclean		: Clean up volume and networks and local mount"
	@echo " ifclean	: Clean up all docker materials"
	@echo " new-host	: change ${DOMAIN_NAME} at /etc/hosts"
	@echo " old-host	: change localhost at /etc/hosts"
	@echo " cat-host	: check /etc/hosts"
	@echo " ssl-check	: check the crt files"
	@echo " ssl-curl	: curl test using ssl"

# for docker
list :
	docker images
	docker ps -a

# イメージを作成
build :
	mkdir -p ${VOLUME_PATH}/mariadb
	mkdir -p ${VOLUME_PATH}/wordpress
	docker-compose -f srcs/docker-compose.yml build

# イメージからコンテナを起動
# entrypointの内容が出力される
up :
	docker-compose -f srcs/docker-compose.yml up

# プロンプトを戻す場合は -d
up-d :
	docker-compose -f srcs/docker-compose.yml up -d

all : build up-d

# 起動コンテナを停止
stop :
	docker-compose -f srcs/docker-compose.yml stop

# コンテナとネットワークを削除
down : stop
	docker-compose -f srcs/docker-compose.yml down

# 使用されていないボリュームとネットワークを削除
clean : down
	docker volume prune --force
	docker network prune --force

# ローカルのマウント先とボリューム、未使用のイメージを削除
fclean : clean
	docker image prune --force
	docker volume rm srcs_wordpress srcs_mariadb
	rm -rf ${VOLUME_PATH}/mariadb
	rm -rf ${VOLUME_PATH}/wordpress

# イメージも全て削除
ifclean : fclean
	docker rmi nginx
	docker rmi mariadb
	docker rmi wordpress

# 名前解決のため/etc/hostsの書き換え
new-host :
	@echo "changing from localhost to ${DOMAIN_NAME} on /etc/hosts"
	sudo sed -i 's/localhost/${DOMAIN_NAME}/' /etc/hosts
	@echo "Done"

old-host :
	@echo "changing from ${DOMAIN_NAME} to localhost on /etc/hosts"
	sudo sed -i 's/${DOMAIN_NAME}/localhost/' /etc/hosts
	@echo "Done"

cat-host :
	@echo "cat /etc/hosts"
	cat /etc/hosts

# for ssl
ssl-check :
	docker cp nginx:/etc/nginx/ssl/nginx.crt ./nginx.crt
	openssl x509 -in ./nginx.crt -text -noout
	rm ./nginx.crt
	
ssl-curl :
	docker cp nginx:/etc/nginx/ssl/nginx.crt ./nginx.crt
	curl -I https://localhost:443 --cacert nginx.crt
	rm ./nginx.crt

.PHONY: help \
		list all \
		build up up-d \
		stop down \
		clean fclean ifclean \
		new-host old-host cat-host \
		ssl-check ssl-curl
