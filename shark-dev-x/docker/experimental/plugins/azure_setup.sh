#!/bin/bash
set -e

source /home/devuser/experimental/config/cli_versions.sh

echo "🔷 Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az version || true
