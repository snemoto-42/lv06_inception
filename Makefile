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
	@echo " ps	: Check docker processes"

# サービスのイメージをビルド
build :
	mkdir -p ${VOLUME_PATH}/mariadb
	mkdir -p ${VOLUME_PATH}/wordpress
	docker-compose -f srcs/docker-compose.yml build

# イメージを作成、イメージからコンテナを起動
# -d：デタッチモード、コマンド実行後にターミナルを即座に戻す
up : build
	docker-compose -f srcs/docker-compose.yml up

# 起動コンテナを停止、コンテナとネットワークを削除、ボリュームは保持
down :
	docker-compose -f srcs/docker-compose.yml down

# 使用されていないボリュームとネットワークを削除
clean : down
	docker volume prune -f
	docker network prune -f
	rm -rf ${VOLUME_PATH}/mariadb
	rm -rf ${VOLUME_PATH}/wordpress

ps :
	docker ps

.PHONY: help build up down clean ps
