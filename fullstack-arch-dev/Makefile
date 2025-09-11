.PHONY: build up down restart logs clean shell

# Build Docker images
build:
	docker-compose build

# Start all services in detached mode
up:
	docker-compose up -d

# Stop all running containers
down:
	docker-compose down

# Restart services
restart: down up

# Tail logs for Superset service
logs:
	docker-compose logs -f superset

# Open a shell inside the Superset container
shell:
	docker exec -it superset /bin/zsh

# Remove all stopped containers and unused images/volumes
clean:
	docker system prune -f
	docker volume prune -f
