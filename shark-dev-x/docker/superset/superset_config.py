# docker/superset/superset_config.py
import os
from cachelib.redis import RedisCache

# ========================
# 🔐 Secrets & Security
# ========================
SECRET_KEY = os.getenv(
    "SECRET_KEY",
    os.getenv("SUPERSET_SECRET_KEY", "sDjoFZIY9nbQF7nwE5ciwaXdOn1xCpiu4yuLTlUOyO0l/dRYMzNXQ9Fp")
)

FERNET_KEY = os.getenv(
    "FERNET_KEY",
    os.getenv("FERNET_KEY", "IOA6I8jZ7IH7-RfM63N2-r0dz6NFDZIhsQMrN_diNqQ=")
)

WTF_CSRF_ENABLED = True

# ========================
# 🔐 Authentication
# ========================
AUTH_TYPE = 1  # Database auth

# ========================
# 🗄️ Database Configuration
# ========================
# Prefer DATABASE_URL from env; fallback to your mysql URI
SQLALCHEMY_DATABASE_URI = os.getenv(
    "DATABASE_URL",
    os.getenv("SQLALCHEMY_DATABASE_URI", "mysql://shark:sharkX404@mysql:3306/superset")
)

# ========================
# 🧠 Caching & Async Queries
# ========================
RESULTS_BACKEND = RedisCache(
    host=os.getenv("REDIS_HOST", "redis"),
    port=int(os.getenv("REDIS_PORT", 6379)),
    key_prefix="superset_results",
    db=int(os.getenv("REDIS_DB", 1))
)

# ========================
# 🍃 Optional MongoDB for plugins
# ========================
# MONGODB_URI = os.getenv("MONGODB_URI")

# ========================
# ⚙️ Feature Flags
# ========================
FEATURE_FLAGS = {
    "GLOBAL_ASYNC_QUERIES": False,
    "SQLLAB_BACKEND_PERSISTENCE": False,
}

# ========================
# 📈 Optional Settings (uncomment/adjust)
# ========================
# ROW_LIMIT = 5000
# SQLALCHEMY_TRACK_MODIFICATIONS = False
# SUPERSET_WEBSERVER_TIMEOUT = 60
