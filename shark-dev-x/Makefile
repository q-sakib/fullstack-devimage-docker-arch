# ===============================
# Variables
# ===============================
COMPOSE=docker-compose -f docker-compose.yml
SERVICES=fullstack appdev ml superset experimental

# ===============================
# Build all or specific services
# ===============================
build: $(SERVICES)

$(SERVICES):
	$(COMPOSE) build $@

# ===============================
# Start all services (dev)
# ===============================
up:
	$(COMPOSE) up -d

# ===============================
# Stop all services
# ===============================
down:
	$(COMPOSE) down

# ===============================
# Rebuild and restart services
# ===============================
restart:
	$(COMPOSE) up -d --build

# ===============================
# Start all services (prod)
# - Uses Docker secrets
# ===============================
up-prod:
	$(COMPOSE) up -d --build --remove-orphans

# ===============================
# View logs
# ===============================
logs:
	$(COMPOSE) logs -f

# ===============================
# Run tests (requires test suites)
# ===============================
test:
	$(COMPOSE) run --rm fullstack pytest || true
	$(COMPOSE) run --rm ml pytest || true
	# Add other service tests as needed

# ===============================
# Clean unused images & containers
# ===============================
clean:
	docker system prune -f

# ===============================
# Clean all volumes and cache
# ===============================
clean-all: clean
	docker volume rm mysql_data postgres_data cache_python cache_node cache_flutter cache_ml_env cache_fullstack_env || true

# ===============================
# Setup caches and persistent directories
# ===============================
setup-cache:
	bash ./scripts/setup_cache.sh

# ===============================
# Post-create setup (Python/Node)
# ===============================
post-create:
	bash ./scripts/post-create.sh

# ===============================
# Common environment install
# ===============================
common-install:
	bash ./scripts/common-install.sh

# ===============================
# CI/CD-friendly commands
# ===============================
ci-build:
	$(COMPOSE) build --pull --no-cache

ci-test:
	$(COMPOSE) run --rm fullstack pytest
	$(COMPOSE) run --rm ml pytest

ci-deploy:
	$(COMPOSE) up -d --build
