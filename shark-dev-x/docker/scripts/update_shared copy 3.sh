#!/usr/bin/env bash
set -e

# The shared folder path
SHARED_DIR="docker/shared"

echo "🔄 Updating shared folder..."
mkdir -p "$SHARED_DIR"

# Loop through all module folders under docker/
for MODULE_DIR in docker/*/; do
    MODULE_NAME=$(basename "$MODULE_DIR")
    
    # Skip the shared and base folders
    if [[ "$MODULE_NAME" == "shared" || "$MODULE_NAME" == "base" ]]; then
        continue
    fi

    echo "➡ Processing $MODULE_NAME..."

    # Copy all files and directories recursively from the module folder into shared
    for ITEM in "$MODULE_DIR"*; do
        if [ -e "$ITEM" ]; then
            cp -ru "$ITEM" "$SHARED_DIR/"
            echo "   ✅ Copied: $(basename "$ITEM")"
        fi
    done
done

echo "🔍 Verifying shared folder contents..."
ls -l "$SHARED_DIR"

echo "✅ Shared folder updated successfully!"
