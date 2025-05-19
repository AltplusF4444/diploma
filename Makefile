# Makefile для управления проектом decentralized-blog

# Переменные
PROJECT_NAME := decentralized-blog
DOCKER_COMPOSE := docker-compose
BUILD_DIR := ./blockchain/build
SHARED_ABI_PATH = /shared/abi.json
SHARED_ADDRESS_PATH = /shared/contract_address.txt
BLOG_JSON_PATH = /app/build/contracts/Blog.json

## Цели (Targets)

# Запустить все сервисы
up:
	@echo "Запуск всех сервисов..."
	$(DOCKER_COMPOSE) up --build

# Запустить все сервисы в фоновом режиме
up-d:
	@echo "Запуск всех сервисов в фоновом режиме..."
	$(DOCKER_COMPOSE) up -d --build

# Остановить все сервисы
down:
	@echo "Остановка всех сервисов..."
	$(DOCKER_COMPOSE) down

# Пересобрать и перезапустить все сервисы
rebuild:
	@echo "Пересборка и перезапуск всех сервисов..."
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) up --build

# Очистить все неиспользуемые Docker-ресурсы
clean:
	@echo "Очистка blockchain ресурсов..."
	$(DOCKER_COMPOSE) exec blockchain rm -rf /app/build/* /app/share/*

# Выполнить миграцию смарт-контрактов
migrate:
	@echo "Выполнение миграции смарт-контрактов..."
	$(DOCKER_COMPOSE) exec blockchain truffle migrate --network ganache
	$(DOCKER_COMPOSE) exec blockchain ./copy_abi.sh

check-artifacts:
	$(DOCKER_COMPOSE) exec backend bash -c "cat $(SHARED_ABI_PATH)"
	$(DOCKER_COMPOSE) exec backend bash -c "cat $(SHARED_ADDRESS_PATH)"

# Открыть Truffle Console для взаимодействия с контрактами
console:
	@echo "Открытие Truffle Console..."
	$(DOCKER_COMPOSE) exec blockchain truffle console --network ganache

# Проверить логи всех сервисов
logs:
	@echo "Просмотр логов всех сервисов..."
	$(DOCKER_COMPOSE) logs --follow

# Проверить логи конкретного сервиса
logs-%:
	@echo "Просмотр логов сервиса $*..."
	$(DOCKER_COMPOSE) logs --follow $*

# Удалить только контейнеры проекта
rm-containers:
	@echo "Удаление контейнеров проекта..."
	$(DOCKER_COMPOSE) rm -fsv

# Удалить образы проекта
rm-images:
	@echo "Удаление образов проекта..."
	docker rmi $(shell docker images --filter=reference='$(PROJECT_NAME)*' -q)

# Список доступных команд
help:
	@echo "Доступные команды:"
	@echo "  make up          - Запустить все сервисы"
	@echo "  make up-d        - Запустить все сервисы в фоновом режиме"
	@echo "  make down        - Остановить все сервисы"
	@echo "  make rebuild     - Пересобрать и перезапустить все сервисы"
	@echo "  make clean       - Очистить все Docker-ресурсы и временные файлы"
	@echo "  make migrate     - Выполнить миграцию смарт-контрактов"
	@echo "  make console     - Открыть Truffle Console"
	@echo "  make logs        - Просмотреть логи всех сервисов"
	@echo "  make logs-<name> - Просмотреть логи конкретного сервиса (например, logs-backend)"
	@echo "  make rm-containers - Удалить контейнеры проекта"
	@echo "  make rm-images   - Удалить образы проекта"
	@echo "  make help        - Показать эту справку"

.PHONY: up up-d down rebuild clean migrate console logs logs-% rm-containers rm-images help