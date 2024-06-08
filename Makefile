# デフォルトのターゲット
.DEFAULT_GOAL := list

# .envのパス
ENV_FILE := ./srcs/.env

# .envの読み込み、シェル環境にエクスポート
# docker-compose.yamlで環境変数を使用
# 各コンテナの環境変数はdocker-composeで読み込み
include $(ENV_FILE)
export

# help :
# 	@echo "Available targets:"
# 	@echo " build	: Build Docker containers"
# 	@echo " up	: Start Docker containers"
# 	@echo " down	: Stop and remove Docker containers"
# 	@echo " clean	: Clean up Docker volume and networks"

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
up : build
	docker-compose -f srcs/docker-compose.yml up

# 起動コンテナを停止、コンテナとネットワークを削除、ボリュームは保持
down :
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

.PHONY: new-host old-host cat-host \
		ssl-check ssl-curl \
		list build up down \
		clean fclean ifclean
