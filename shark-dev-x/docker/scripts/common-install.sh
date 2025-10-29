#!/bin/bash
set -euo pipefail

echo "🔧 Running common-install.sh"

# -------------------------
# 1️⃣ Ensure Python & pip
# -------------------------
if ! command -v python3 &>/dev/null; then
    echo "⚠️ Python3 not found, installing..."
    sudo apt-get update
    sudo apt-get install -y python3 python3-venv python3-pip
fi

# -------------------------
# 2️⃣ Ensure Node.js & npm
# -------------------------
if ! command -v node &>/dev/null; then
    echo "⚠️ Node.js not found, installing..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# -------------------------
# 3️⃣ Ensure Yarn
# -------------------------
if ! command -v yarn &>/dev/null; then
    echo "⚠️ Yarn not found, installing..."
    npm install -g yarn
fi

# -------------------------
# 4️⃣ Python global packages
# -------------------------
echo "📦 Installing global Python packages..."
pip install --upgrade pip setuptools wheel virtualenv

echo "✅ Common install complete"
