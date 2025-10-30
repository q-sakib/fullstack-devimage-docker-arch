#!/usr/bin/env bash
set -euo pipefail
echo "🔧 Setting up Debian base image..."
python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel virtualenv
pip install --no-cache-dir ipython httpie
echo "✅ Debian base system setup complete."
