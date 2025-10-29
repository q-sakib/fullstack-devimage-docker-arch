# ------------------------------
# Variables
# ------------------------------
COMPOSE=docker-compose -f docker-compose.yml
SERVICES=fullstack appdev ml superset experimental

# ------------------------------
# Build all or specific services
# ------------------------------
build: $(SERVICES)

$(SERVICES):
	$(COMPOSE) build $@

# ------------------------------
# Start all services
# ------------------------------
up:
	$(COMPOSE) up -d

# ------------------------------
# Stop all services
# ------------------------------
down:
	$(COMPOSE) down

# ------------------------------
# Rebuild and restart specific service
# ------------------------------
restart:
	$(COMPOSE) up -d --build

# ------------------------------
# View logs
# ------------------------------
logs:
	$(COMPOSE) logs -f

# ------------------------------
# Clean unused images
# ------------------------------
clean:
	docker system prune -f
