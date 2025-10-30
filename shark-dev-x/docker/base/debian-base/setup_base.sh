#!/usr/bin/env bash
set -euo pipefail
echo "🔧 Setting up Debian base image..."

# Create isolated venv for Python
python3 -m venv /opt/venv
/opt/venv/bin/pip install --upgrade pip setuptools wheel virtualenv
/opt/venv/bin/pip install ipython httpie rich

echo "✅ Debian base system setup complete."
