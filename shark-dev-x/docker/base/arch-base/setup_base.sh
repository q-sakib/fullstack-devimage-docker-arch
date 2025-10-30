#!/usr/bin/env bash
set -euo pipefail
echo "🔧 Setting up Arch base image..."

# Python venv
python -m venv /opt/venv
/opt/venv/bin/pip install --upgrade pip setuptools wheel virtualenv
/opt/venv/bin/pip install ipython httpie rich

echo "✅ Arch base system setup complete."
