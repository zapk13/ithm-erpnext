# ERPNext ITHM Education Portal - Makefile
# Quick commands for development and management

.PHONY: help start stop restart logs setup reset backup restore migrate build console shell clean install

# Default target
help: ## Show this help message
	@echo "ERPNext Education Portal - Institute of Tourism and Hospitality Management"
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

start: ## Start all services
	@echo "🚀 Starting ERPNext ITHM Education Portal..."
	docker-compose up -d
	@echo "✅ Services started! Access at http://localhost:8000"

stop: ## Stop all services
	@echo "🛑 Stopping all services..."
	docker-compose down
	@echo "✅ All services stopped"

restart: ## Restart all services
	@echo "🔄 Restarting services..."
	docker-compose restart
	@echo "✅ Services restarted"

logs: ## Show logs for all services
	docker-compose logs -f

setup: ## Initial setup and start
	@echo "🏗️ Setting up ERPNext ITHM Education Portal..."
	docker-compose up -d
	@echo "⏳ Waiting for setup to complete..."
	docker-compose logs -f erpnext

reset: ## Reset everything (WARNING: Deletes all data)
	@echo "⚠️  WARNING: This will delete all data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	if [[ $REPLY =~ ^[Yy]$ ]]; then \
		echo ""; \
		echo "🗑️ Removing all data and containers..."; \
		docker-compose down -v; \
		echo "🏗️ Rebuilding and starting fresh..."; \
		docker-compose up -d --build; \
	else \
		echo ""; \
		echo "❌ Reset cancelled"; \
	fi

backup: ## Create backup of the site
	@echo "💾 Creating backup..."
	docker-compose exec erpnext bench --site ithm.local backup
	@echo "✅ Backup completed"

restore: ## Restore from backup (provide BACKUP_FILE=path)
	@echo "📥 Restoring from backup..."
	docker-compose exec erpnext bench --site ithm.local restore $(BACKUP_FILE)
	@echo "✅ Restore completed"

migrate: ## Run database migrations
	@echo "🔄 Running migrations..."
	docker-compose exec erpnext bench --site ithm.local migrate
	@echo "✅ Migrations completed"

build: ## Build assets
	@echo "🔨 Building assets..."
	docker-compose exec erpnext bench build
	@echo "✅ Assets built"

console: ## Open ERPNext console
	@echo "🖥️ Opening ERPNext console..."
	docker-compose exec erpnext bench --site ithm.local console

shell: ## Open bash shell in ERPNext container
	@echo "🐚 Opening shell..."
	docker-compose exec erpnext bash

clean: ## Clean up Docker resources
	@echo "🧹 Cleaning up Docker resources..."
	docker system prune -f
	@echo "✅ Cleanup completed"

install: ## Install additional apps (provide APP_NAME=name)
	@echo "📦 Installing app: $(APP_NAME)"
	docker-compose exec erpnext bench get-app $(APP_NAME)
	docker-compose exec erpnext bench --site ithm.local install-app $(APP_NAME)
	@echo "✅ App $(APP_NAME) installed"

status: ## Show status of all services
	@echo "📊 Service Status:"
	docker-compose ps

update: ## Update ERPNext and apps
	@echo "🔄 Updating ERPNext..."
	docker-compose exec erpnext bench update --no-backup
	@echo "✅ Update completed"

dev: ## Start in development mode
	@echo "💻 Starting in development mode..."
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
	@echo "✅ Development environment started"