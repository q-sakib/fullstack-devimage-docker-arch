#!/usr/bin/env bash
set -euo pipefail
echo "🔧 Setting up Ubuntu base image..."

# Upgrade Python tooling
python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel virtualenv

# Basic convenience tools
pip install --no-cache-dir ipython rich httpie

# Install Oh My Zsh + Plugins handled by user_setup.sh, no duplication here
echo "✅ Ubuntu base system setup complete."
