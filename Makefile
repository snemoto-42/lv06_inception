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

# サービスのイメージをビルド、Docker imageの作成
build :
	docker-compose -f srcs/docker-compose.yml build

# サービスをバックグラウンドで起動、Docker containerが起動
# -d を付けるとデタッチモード、コマンド実行後にターミナルを即座に戻す
up :
	docker-compose -f srcs/docker-compose.yml up --build

# Dockerコンテナを停止、削除
# 起動されたコンテナを停止、停止したコンテナとネットワークを削除。ボリュームは保持される
down :
	docker-compose -f srcs/docker-compose.yml down

# 使用されていないDockerボリュームとネットワークを削除
clean :
	docker volume prune -f
	docker network prune -f

.PHONY: help build up down clean
