# ===============================
# Variables
# ===============================
COMPOSE=docker-compose -f docker-compose.yml
SERVICES=fullstack appdev ml superset experimental mysql postgres redis
PROFILE?=dev  # default profile: dev

# ===============================
# Build all or specific services
# ===============================
build: $(SERVICES)

$(SERVICES):
	@echo "🔧 Building service: $@ (profile: $(PROFILE))"
	$(COMPOSE) build --build-arg PROFILE=$(PROFILE) $@

# ===============================
# Start all services (dev)
# ===============================
up:
	@echo "🚀 Starting all services (profile: $(PROFILE))"
	$(COMPOSE) up -d

# Start selected profile services
up-profile:
	@echo "🚀 Starting profile: $(PROFILE)"
ifeq ($(PROFILE), dev)
	$(COMPOSE) up -d fullstack ml superset
endif
ifeq ($(PROFILE), analytics)
	$(COMPOSE) up -d superset ml
endif
ifeq ($(PROFILE), admin)
	$(COMPOSE) up -d super-admin-all
endif

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

logs-%:
	$(COMPOSE) logs -f $*

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
	$(COMPOSE) up -d --build --remove-orphans

# ===============================
# Secrets Management (example)
# ===============================
setup-secrets:
	@echo "🔐 Creating Docker secrets for prod"
	@mkdir -p docker/secrets
	@echo "$${MYSQL_ROOT_PASSWORD:-sharkX404}" > docker/secrets/mysql_root_password.txt
	@echo "$${MYSQL_PASSWORD:-sharkX404}" > docker/secrets/mysql_password.txt
	@echo "$${POSTGRES_PASSWORD:-sharkX404}" > docker/secrets/postgres_password.txt
	@echo "$${REDIS_PASSWORD:-sharkX404}" > docker/secrets/redis_password.txt
	@echo "✅ Secrets created"

# ===============================
# Quick start: full setup
# ===============================
init: common-install setup-cache post-create build up
	@echo "🚀 All services built and running!"
