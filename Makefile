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
	@echo " build	: Build Docker containers"
	@echo " up	: Start Docker containers"
	@echo " down	: Stop and remove Docker containers"
	@echo " clean	: Clean up Docker volume and networks"

# 名前解決のため/etc/hostsの書き換え
add-host :
	@echo "Adding ${DOMAIN_NAME} to /etc/hosts"
	@sudo sh -c 'echo "127.0.0.1 ${DOMAIN_NAME}" >> /etc/hosts'
	@echo "Done"

# サービスのイメージをビルド
build :
	mkdir -p ${VOLUME_PATH}/mariadb
	mkdir -p ${VOLUME_PATH}/wordpress
	docker-compose -f srcs/docker-compose.yml build

# イメージを作成、イメージからコンテナを起動
up : build
	docker-compose -f srcs/docker-compose.yml up

# 起動コンテナを停止、コンテナとネットワークを削除、ボリュームは保持
down :
	docker-compose -f srcs/docker-compose.yml down

# 使用されていないボリュームとネットワークを削除
clean : down
	docker volume prune --force
	docker network prune --force

# ローカルのマウント先を削除
fclean : clean
	docker image prune --force
	rm -rf ${VOLUME_PATH}/mariadb
	rm -rf ${VOLUME_PATH}/wordpress

.PHONY: help add-host build up down clean fclean
