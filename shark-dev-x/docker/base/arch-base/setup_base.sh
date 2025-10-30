#!/usr/bin/env bash
set -euo pipefail
echo "🔧 Setting up Arch base image..."
python -m pip install --no-cache-dir --upgrade pip setuptools wheel virtualenv
pip install --no-cache-dir ipython httpie
echo "✅ Arch base system setup complete."
