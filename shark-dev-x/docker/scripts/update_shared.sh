#!/usr/bin/env bash
set -e

# The module name is passed as the first argument (appdev, fullstack, ml, experimental)
MODULE="$1"

# Shared folder location
SHARED_DIR="docker/shared"

# Create shared folder if missing
mkdir -p "$SHARED_DIR"

echo "🔄 Updating shared folder for module: $MODULE..."

# Loop through all modules under docker/
for MODULE_DIR in docker/*/; do
    MOD_NAME=$(basename "$MODULE_DIR")

    # Skip base and shared folders
    if [[ "$MOD_NAME" == "shared" || "$MOD_NAME" == "base" ]]; then
        continue
    fi

    echo "➡ Processing $MOD_NAME..."

    # Copy all files if they exist
    if compgen -G "$MODULE_DIR"* > /dev/null; then
        for ITEM in "$MODULE_DIR"*; do
            # Only copy if it’s a file or directory
            if [ -f "$ITEM" ]; then
                cp -u "$ITEM" "$SHARED_DIR/" && echo "   ✅ File copied: $(basename "$ITEM")"
            elif [ -d "$ITEM" ]; then
                cp -ru "$ITEM" "$SHARED_DIR/" && echo "   ✅ Directory copied: $(basename "$ITEM")"
            fi
        done
    else
        echo "   ⚠️ No files/folders found in $MOD_NAME, skipping..."
    fi
done

echo "🔍 Verifying shared folder contents..."
ls -l "$SHARED_DIR" || echo "⚠️ Shared folder is empty"

echo "✅ Shared folder updated successfully!"
