#!/bin/bash
set -euo pipefail

echo "🗂 Setting up persistent cache directories..."

DEV_HOME=${DEV_HOME:-/home/devuser}
CACHE_DIR="$DEV_HOME/.cache"

mkdir -p "$CACHE_DIR/python" \
         "$CACHE_DIR/node" \
         "$CACHE_DIR/flutter" \
         "$CACHE_DIR/ml-env" \
         "$CACHE_DIR/fullstack-env"

echo "✅ Cache directories ready:"
ls -ld "$CACHE_DIR"/*

echo "💡 You can mount $CACHE_DIR to your host for persistent cache"
