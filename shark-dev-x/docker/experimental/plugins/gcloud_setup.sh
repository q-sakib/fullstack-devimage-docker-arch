#!/bin/bash
set -e

echo "☁️ Installing Google Cloud SDK..."
curl -sSL https://sdk.cloud.google.com | bash
export PATH="$HOME/google-cloud-sdk/bin:$PATH"
gcloud version || true
