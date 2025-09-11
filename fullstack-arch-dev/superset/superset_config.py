import os
from cachelib.redis import RedisCache

# ========================
# 🔐 Secrets & Security
# ========================
SECRET_KEY = os.getenv(
    "SECRET_KEY",
    "sDjoFZIY9nbQF7nwE5ciwaXdOn1xCpiu4yuLTlUOyO0l/dRYMzNXQ9Fp"  # Replace for production
)

FERNET_KEY = os.getenv(
    "FERNET_KEY",
    "IOA6I8jZ7IH7-RfM63N2-r0dz6NFDZIhsQMrN_diNqQ="  # Replace for production
)
# assert SECRET_KEY, "SECRET_KEY must be set in environment"
# assert FERNET_KEY, "FERNET_KEY must be set in environment"
# CSRF Protection (enabled by default)
WTF_CSRF_ENABLED = True

# ========================
# 🔐 Authentication
# ========================
AUTH_TYPE = 1  # Database authentication (use 2 for LDAP, etc.)

# ========================
# 🗄️  Database Configuration
# ========================
SQLALCHEMY_DATABASE_URI = os.getenv(
    "DATABASE_URL",
    "mysql://shark:sharkX404@mysql:3306/superset"
)

# ========================
# 🧠 Caching & Async Queries
# ========================
RESULTS_BACKEND = RedisCache(
    host=os.getenv("REDIS_HOST", "redis"),
    port=int(os.getenv("REDIS_PORT", 6379)),
    key_prefix="superset_results",
    db=1,
)

# ========================
# 🍃 MongoDB Integration (Optional for custom plugins)
# ========================
MONGODB_URI = os.getenv(
    "MONGODB_URI",
    "mongodb://shark:sharkX404@mongodb:27017/superset"
)

# ========================
# ⚙️ Feature Flags
# ========================
FEATURE_FLAGS = {
    "GLOBAL_ASYNC_QUERIES": False,
    "SQLLAB_BACKEND_PERSISTENCE": False,
    # Add more feature flags if needed
}

# ========================
# 📈 Optional Settings
# ========================
# ROW_LIMIT = 5000
# ENABLE_TIME_ROTATE = True
# SUPERSET_WEBSERVER_TIMEOUT = 60
# SQLALCHEMY_TRACK_MODIFICATIONS = False
