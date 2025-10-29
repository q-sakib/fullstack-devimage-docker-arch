#!/bin/bash
set -euo pipefail

echo "🚀 Running post-create setup..."

DEV_HOME=${DEV_HOME:-/home/devuser}
cd "$DEV_HOME/workspace"

# -------------------------
# 1️⃣ Load shared environment
# -------------------------
if [ -f "/tmp/common_env.sh" ]; then
    source /tmp/common_env.sh
fi

# -------------------------
# 2️⃣ Install Python requirements (if exists)
# -------------------------
if [ -f "requirements.txt" ]; then
    echo "📦 Installing Python project dependencies..."
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt
fi

# -------------------------
# 3️⃣ Install Node.js packages (if package.json exists)
# -------------------------
if [ -f "package.json" ]; then
    echo "📦 Installing Node.js project dependencies..."
    npm install
fi

# -------------------------
# 4️⃣ Final message
# -------------------------
echo "✅ Post-create setup complete"
