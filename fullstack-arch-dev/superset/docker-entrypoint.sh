#!/bin/bash
set -euo pipefail

echo "▶️ Starting Superset Setup..."

# Activate virtual environment
source /home/devuser/superset-env/bin/activate
echo "Virtual env activated: $(which python)"

# Function to wait for a service to be ready
wait_for_service() {
  local host=$1
  local port=$2
  echo "⏳ Waiting for $host:$port to be available..."
  until nc -z "$host" "$port"; do
    sleep 2
  done
  echo "✅ $host:$port is up."
}

# Wait for all dependent services
wait_for_service "mysql" 3306
wait_for_service "postgres" 5432
wait_for_service "redis" 6379
# wait_for_service "mongodb" 27017

echo "✅ All dependencies are up."

# Run DB migrations
echo "🔄 Running database migrations..."
superset db upgrade

# Create admin user (ignore error if user exists)
echo "👤 Creating admin user if not exists..."
superset fab create-admin \
  --username "${SUPERSET_USERNAME:-admin}" \
  --firstname Superset \
  --lastname Admin \
  --email "${SUPERSET_EMAIL:-admin@superset.com}" \
  --password "${SUPERSET_PASSWORD:-admin}" || true

# Initialize Superset
echo "⚙️ Initializing Superset..."
superset init

# Start Superset server
echo "🚀 Starting Superset server on 0.0.0.0:8088..."
# exec superset run -h 0.0.0.0 -p 8088 --with-threads --reload --debugger
exec gunicorn -w 3 -k gevent --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()"
