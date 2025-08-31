# Wort-Wirbel Makefile
# Provides convenient commands for both Docker and Flutter SDK workflows

.PHONY: help install dev build test lint format clean docker-dev docker-prod docker-local docker-clean

help: ## Show this help message
	@echo "Wort-Wirbel 🌪️ - Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install Flutter dependencies
	flutter pub get

dev: ## Run app in development mode (Chrome)
	flutter run -d chrome

dev-server: ## Run app with hot reload on web server
	flutter run -d web-server --web-hostname localhost --web-port 8080

build: ## Build for production
	flutter build web --release

build-profile: ## Build with profiling enabled
	flutter build web --profile

test: ## Run all tests
	flutter test

test-coverage: ## Run tests with coverage report
	flutter test --coverage

test-watch: ## Run tests in watch mode (requires entr)
	find test/ -name "*.dart" | entr -r flutter test

lint: ## Run code analysis
	flutter analyze

format: ## Format all Dart code
	dart format .

format-check: ## Check if code is properly formatted (CI-friendly)
	dart format --output=none --set-exit-if-changed .

clean: ## Clean build artifacts
	flutter clean

docker-local: ## Run with Docker for local development (hot reload)
	docker-compose --profile local up wort-wirbel-local

docker-dev: ## Run development build with Docker
	docker-compose --profile dev up --build wort-wirbel-dev

docker-prod: ## Run production build with Docker
	docker-compose --profile prod up --build wort-wirbel-prod

docker-clean: ## Clean up Docker containers and images
	docker-compose down --volumes --remove-orphans
	docker system prune -f

start: ## Quick start for development (uses Flutter SDK)
	@echo "🚀 Starting Wort-Wirbel development server..."
	@make install
	@make dev-server

start-docker: ## Quick start with Docker (recommended for new developers)
	@echo "🐳 Starting Wort-Wirbel with Docker..."
	@make docker-local

qa: ## Run full quality assurance suite
	@echo "🔍 Running quality assurance checks..."
	@make format-check
	@make lint
	@make test-coverage

qa-fix: ## Fix code quality issues
	@echo "🔧 Fixing code quality issues..."
	@make format
	@make test

ci-test: ## Run CI-compatible test suite
	@make format-check
	@make lint
	@make test-coverage

prod-build: ## Build optimized production image
	docker build -t wort-wirbel:latest .

prod-run: ## Run production container locally
	docker run -p 80:80 --name wort-wirbel-prod wort-wirbel:latest

prod-stop: ## Stop production container
	docker stop wort-wirbel-prod || true
	docker rm wort-wirbel-prod || true

serve-build: ## Serve production build locally (requires Python)
	@echo "📦 Serving production build at http://localhost:8000"
	cd build/web && python -m http.server 8000

doctor: ## Run Flutter doctor to check setup
	flutter doctor

upgrade: ## Upgrade Flutter dependencies
	flutter pub upgrade

tdd-red: ## Create a new test file (Red phase)
	@read -p "Enter test file name (without .dart): " name; \
	touch test/$${name}_test.dart; \
	echo "✅ Created test/$${name}_test.dart - Write your failing test!"

tdd-green: ## Run specific test file (Green phase)
	@read -p "Enter test file name (without _test.dart): " name; \
	flutter test test/$${name}_test.dart

tdd-refactor: ## Run full test suite after refactoring
	@echo "♻️  Running full test suite for refactoring validation..."
	@make test
