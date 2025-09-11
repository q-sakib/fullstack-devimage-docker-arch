#!/bin/bash

# --- Configurable variables ---
MYSQL_ROOT_PASSWORD="sharkX404"
SUPERSET_VENV_PATH="/home/shark/.pyenv/versions/superset-venv"
SUPERSET_HOME="/home/shark"
SUPERSET_CONFIG_PATH="${SUPERSET_HOME}/.superset/superset_config.py"

echo "Starting setup..."

# --- Redis (Valkey) check & start ---
if ! command -v redis-server &> /dev/null; then
    echo "Redis (Valkey) not found, installing..."
    sudo pacman -Syu --noconfirm valkey
fi

echo "Starting Redis service..."
sudo systemctl start redis
sudo systemctl enable redis
sudo systemctl status redis --no-pager

# --- MariaDB check & start ---
if ! command -v mariadbd &> /dev/null; then
    echo "MariaDB not found, installing..."
    sudo pacman -Syu --noconfirm mariadb
    sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

echo "Starting MariaDB service..."
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb --no-pager

# --- Check MySQL root login works ---
echo "Checking MySQL root access..."
if ! mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1;" &> /dev/null; then
    echo "❌ Cannot log in to MySQL with the provided root password."
    echo "You may need to reset it manually using 'mysql_secure_installation' or update the script with the correct password."
    exit 1
else
    echo "✅ MySQL root access verified."
fi

# --- Write the superset_config.py file ---
echo "Writing superset_config.py..."
mkdir -p "$(dirname "$SUPERSET_CONFIG_PATH")"
cat > "$SUPERSET_CONFIG_PATH" <<EOF
SECRET_KEY = "WsFZB1gDceQRSLXWX2sm2A8bCfY5vj4auTLtpeuEUtSjExuxSnvBan03RRUrlc1CCc8CNoYu5q8N32i/Xj3zDg=="

from cachelib.redis import RedisCache

RESULTS_BACKEND = RedisCache(
    host='localhost',
    port=6379,
    key_prefix='superset_results',
    db=1,
)

FEATURE_FLAGS = {
    "GLOBAL_ASYNC_QUERIES": False,
    "SQLLAB_BACKEND_PERSISTENCE": False,
}
EOF

# --- Superset virtualenv check ---
if [ ! -d "${SUPERSET_VENV_PATH}" ]; then
    echo "Superset virtual environment not found at ${SUPERSET_VENV_PATH}"
    exit 1
fi

echo "Activating Superset virtualenv..."
source "${SUPERSET_VENV_PATH}/bin/activate"
export SUPERSET_HOME="${SUPERSET_HOME}"

# --- Start Superset server ---
echo "Starting Superset server..."
nohup superset run -p 8088 --with-threads --reload --debugger > superset.log 2>&1 &

# --- Start Celery worker ---
echo "Starting Celery worker..."
nohup celery --app=superset.tasks.celery_app:app worker --pool=solo -O fair --loglevel=INFO > celery.log 2>&1 &

echo "✅ All services started. Check superset.log and celery.log for output."
