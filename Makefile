# デフォルトのターゲット
.DEFAULT_GOAL := help

# .envのパス
ENV_FILE := ./srcs/.env

# .envの読み込み
include $(ENV_FILE)
export

#ヘルプ
help :
	@echo "Available targets:"
	@echo " build	: Build Docker containers"
	@echo " up		: Start Docker containers"
	@echo " down	: Stop and remove Docker containers"
	@echo " clean	: Clean up Docker volume and networks"

# Dockerコンテナをビルド
build :
	docker-compose build

# Dockerコンテナを起動
up :
	docker-compose up -d

# Dockerコンテナを停止、削除
down :
	docker-compose down

# 使用されていないDockerボリュームとネットワークを削除
clean :
	docker volume prune -f
	docker network prune -f

.PHONY: help build up down clean
