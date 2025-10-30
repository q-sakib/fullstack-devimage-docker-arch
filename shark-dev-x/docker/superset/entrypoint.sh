#!/usr/bin/env bash
set -euo pipefail

DEV_USER=${DEV_USER:-devuser}
HOME_DIR=${HOME:-/home/${DEV_USER}}
VENV=/opt/superset-venv

# Activate virtualenv
if [ -d "$VENV" ]; then
    source "$VENV/bin/activate"
fi

echo "▶️ Superset entrypoint: mode='${MODE:-dev}', user='${DEV_USER}', python=$(which python)"

# Wait for services if env provided
wait_for_service() {
  local host="$1" port="$2" timeout="${3:-120}" elapsed=0
  [ -z "$host" ] || [ -z "$port" ] && return 0
  echo "⏳ Waiting for $host:$port (timeout ${timeout}s)..."
  until nc -z "$host" "$port" >/dev/null 2>&1 || [ "$elapsed" -ge "$timeout" ]; do
    sleep 2
    elapsed=$((elapsed+2))
  done
  [ "$elapsed" -ge "$timeout" ] && echo "⚠️ Timeout waiting for $host:$port" && return 1
  echo "✅ $host:$port is available"
}

: "${MYSQL_HOST:=mysql}" "${MYSQL_PORT:=3306}"
: "${POSTGRES_HOST:=postgres}" "${POSTGRES_PORT:=5432}"
: "${REDIS_HOST:=redis}" "${REDIS_PORT:=6379}"

wait_for_service "$MYSQL_HOST" "$MYSQL_PORT" 60 || true
wait_for_service "$POSTGRES_HOST" "$POSTGRES_PORT" 10 || true
wait_for_service "$REDIS_HOST" "$REDIS_PORT" 10 || true

# DB migrations and init
if [ "${MODE:-dev}" = "prod" ] || [ "${RUN_SUPERSET_INIT:-0}" = "1" ]; then
    echo "🔄 Running superset db upgrade..."
    superset db upgrade || true
    echo "👤 Ensure admin user exists..."
    superset fab create-admin \
      --username "${SUPERSET_USERNAME:-admin}" \
      --firstname "${SUPERSET_FIRSTNAME:-Superset}" \
      --lastname "${SUPERSET_LASTNAME:-Admin}" \
      --email "${SUPERSET_EMAIL:-admin@localhost}" \
      --password "${SUPERSET_PASSWORD:-admin}" || true
    echo "⚙️ Initializing superset..."
    superset init || true
fi

# Interactive shell for dev
if [ "${1:-}" = "shell" ] || [ "${MODE:-dev}" = "dev" ]; then
    [ -f /opt/docker-shared/common_env.sh ] && source /opt/docker-shared/common_env.sh || true
    [ -f /opt/zsh_aliases ] && source /opt/zsh_aliases || true
    exec zsh -l
fi

# Production server
if [ "${MODE:-dev}" = "prod" ]; then
    mkdir -p /home/${DEV_USER}
    exec gunicorn -w 3 -k gevent --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()"
fi

# Run any custom command
exec "$@"
