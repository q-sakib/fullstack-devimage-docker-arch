SECRET_KEY = "sDjoFZIY9nbQF7nwE5ciwaXdOn1xCpiu4yuLTlUOyO0l/dRYMzNXQ9Fp"
FERNET_KEY = "IOA6I8jZ7IH7-RfM63N2-r0dz6NFDZIhsQMrN_diNqQ="
from cachelib.redis import RedisCache
AUTH_TYPE = 1  # Enable database authentication
WTF_CSRF_ENABLED = True

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
