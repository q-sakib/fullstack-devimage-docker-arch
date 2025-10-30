"""
🌐 Fullstack App Configuration
Unified config loader for Python backends (Flask, FastAPI, Django, etc.)
"""

import os
from pathlib import Path
from dotenv import load_dotenv

# -------------------------------------------------------------------
# Load environment variables
# -------------------------------------------------------------------
ENV_PATH = Path("/env/.env")
if ENV_PATH.exists():
    load_dotenv(ENV_PATH)

# -------------------------------------------------------------------
# Core configuration
# -------------------------------------------------------------------
class Config:
    APP_NAME = os.getenv("APP_NAME", "FullstackApp")
    DEBUG = os.getenv("DEBUG", "false").lower() == "true"

    # Database settings
    DB_USER = os.getenv("DB_USER", "user")
    DB_PASS = os.getenv("DB_PASS", "password")
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_PORT = os.getenv("DB_PORT", "5432")
    DB_NAME = os.getenv("DB_NAME", "appdb")

    SQLALCHEMY_DATABASE_URI = (
        f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )

    # Redis configuration
    REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379/0")

    # JWT or session secrets
    SECRET_KEY = os.getenv("SECRET_KEY", "super-secret-key")

    # API settings
    API_PREFIX = os.getenv("API_PREFIX", "/api/v1")
    CORS_ORIGINS = os.getenv("CORS_ORIGINS", "*").split(",")


config = Config()
