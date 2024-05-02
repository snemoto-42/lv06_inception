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

ps :
	docker ps

# サービスのイメージをビルド
build :
	docker-compose -f srcs/docker-compose.yml build

# イメージを作成、イメージからコンテナを起動
# -d：デタッチモード、コマンド実行後にターミナルを即座に戻す
up :
	docker-compose -f srcs/docker-compose.yml up --build

# コンテナを停止、削除
# 起動コンテナを停止、コンテナとネットワークを削除、ボリュームは保持
down :
	docker-compose -f srcs/docker-compose.yml down

# 使用されていないボリュームとネットワークを削除
clean :
	docker volume prune -f
	docker network prune -f

.PHONY: help build up down clean ps
