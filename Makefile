# デフォルトのターゲット
.DEFAULT_GOAL := help

# .envのパス
ENV_FILE := ./srcs/.env

# .envの読み込み、シェル環境にエクスポート
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
	docker-compose build

# サービスをバックグラウンドで起動、Docker containerが起動
# -d はデタッチモード、コマンド実行後にターミナルを即座に戻す
up :
	docker-compose up -d

# Dockerコンテナを停止、削除
# 起動されたコンテナを停止、停止したコンテナとネットワークを削除。ボリュームは保持される
down :
	docker-compose down

# 使用されていないDockerボリュームとネットワークを削除
clean :
	docker volume prune -f
	docker network prune -f

.PHONY: help build up down clean
