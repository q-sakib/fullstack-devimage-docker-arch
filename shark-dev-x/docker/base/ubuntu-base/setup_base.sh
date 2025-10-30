#!/usr/bin/env bash
set -euo pipefail
echo "🔧 Setting up Ubuntu base image..."
python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel virtualenv
pip install --no-cache-dir ipython rich httpie
echo "✅ Ubuntu base system setup complete."
