#!/usr/bin/env bash
# docker/superset/entrypoint.sh
# Robust startup script for Superset.
# - sources virtualenv
# - waits for dependent services
# - runs DB migrations
# - creates admin user if needed
# - runs either an interactive shell (dev) or starts Gunicorn (prod)
set -euo pipefail

# If running as root, drop to DEV_USER if defined
DEV_USER=${DEV_USER:-devuser}
HOME_DIR=${HOME:-/home/${DEV_USER}}

# Activate venv if present
VENV=/opt/superset-venv
if [ -d "$VENV" ]; then
  # shellcheck disable=SC1090
  source "$VENV/bin/activate"
fi

# Ensure python command is available
if ! command -v python >/dev/null 2>&1; then
  echo "ERROR: python not found in PATH. Is the venv set up?"; exit 1
fi

echo "▶️ Superset entrypoint: mode='${MODE:-dev}', user='${DEV_USER}', python=$(which python)"

# helper: wait for host:port until available (timeout optional)
wait_for_service() {
  local host="$1" port="$2" timeout="${3:-120}" elapsed=0
  if [ -z "$host" ] || [ -z "$port" ]; then
    return 0
  fi
  echo "⏳ Waiting for $host:$port (timeout ${timeout}s)..."
  until nc -z "$host" "$port" >/dev/null 2>&1 || [ "$elapsed" -ge "$timeout" ]; do
    sleep 2
    elapsed=$((elapsed+2))
  done
  if [ "$elapsed" -ge "$timeout" ]; then
    echo "⚠️ Timeout waiting for $host:$port"
    return 1
  fi
  echo "✅ $host:$port is available"
}

# Wait for commonly used services — these envs may or may not be present
: "${MYSQL_HOST:=mysql}"
: "${MYSQL_PORT:=3306}"
: "${POSTGRES_HOST:=postgres}"
: "${POSTGRES_PORT:=5432}"
: "${REDIS_HOST:=redis}"
: "${REDIS_PORT:=6379}"

# Try wait for DBs if reachable (fail gracefully if not)
wait_for_service "$MYSQL_HOST" "$MYSQL_PORT" 60 || true
wait_for_service "$POSTGRES_HOST" "$POSTGRES_PORT" 10 || true
wait_for_service "$REDIS_HOST" "$REDIS_PORT" 10 || true

# Run DB migrations and init only when in prod or when explicitly requested
if [ "${MODE:-dev}" = "prod" ] || [ "${RUN_SUPERSET_INIT:-0}" = "1" ]; then
  echo "🔄 Running superset db upgrade..."
  superset db upgrade || true

  echo "👤 Ensure admin user exists (create if missing)..."
  # create admin (ignore error if exists)
  superset fab create-admin \
    --username "${SUPERSET_USERNAME:-admin}" \
    --firstname "${SUPERSET_FIRSTNAME:-Superset}" \
    --lastname "${SUPERSET_LASTNAME:-Admin}" \
    --email "${SUPERSET_EMAIL:-admin@localhost}" \
    --password "${SUPERSET_PASSWORD:-admin}" || true

  echo "⚙️ Initializing superset..."
  superset init || true
fi

# Developer convenience: if first argument is "shell" or MODE=dev, open an interactive shell
if [ "${1:-}" = "shell" ] || [ "${MODE:-dev}" = "dev" ]; then
  # load shared env (safe)
  [ -f /opt/docker-shared/common_env.sh ] && source /opt/docker-shared/common_env.sh || true
  [ -f /opt/zsh_aliases ] && source /opt/zsh_aliases || true
  exec zsh -l
fi

# In production mode, start Gunicorn with recommended Superset app factory
if [ "${MODE:-dev}" = "prod" ]; then
  # ensure logs exist and are writable
  mkdir -p /home/${DEV_USER}
  exec gunicorn -w 3 -k gevent --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()"
fi

# If user passed a custom command, run it
exec "$@"
