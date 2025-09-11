# Fullstack-Arch-Dev

A seamless fullstack development environment based on Arch Linux with Apache Superset, MySQL, PostgreSQL, Redis, and MongoDB.

## Features

- Custom Arch Linux base container with all essential dev tools
- Preconfigured Superset with MySQL backend and Redis cache
- Support for PostgreSQL and MongoDB (optional)
- Virtualenv-based Superset environment with auto DB migration and initialization
- Easy-to-use aliases for Superset CLI
- Single `docker-compose` setup for all services
- `.env` based configuration for easy environment customization

## Requirements

- Docker >= 20.10
- Docker Compose >= 1.29
- Linux/macOS or Windows WSL2

## Quick Start

1. Clone the repo:

   ```bash
   git clone <your-repo-url>
   cd fullstack-arch-dev
