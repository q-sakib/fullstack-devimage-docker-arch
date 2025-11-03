#!/usr/bin/env bash
set -e

# Root folder for shared scripts
SHARED_DIR="docker/shared"

echo "🔄 Updating shared folder..."
mkdir -p "$SHARED_DIR"

# Loop through all module folders under docker/
for MODULE_DIR in docker/*/; do
    MODULE_NAME=$(basename "$MODULE_DIR")

    # Skip shared and base folders
    if [[ "$MODULE_NAME" == "shared" || "$MODULE_NAME" == "base" ]]; then
        continue
    fi

    echo "➡ Processing module: $MODULE_NAME"

    # Copy files (non-recursive)
    if compgen -G "$MODULE_DIR"* >/dev/null; then
        for FILE in "$MODULE_DIR"*; do
            if [ -f "$FILE" ]; then
                cp -u "$FILE" "$SHARED_DIR/" || echo "⚠️ Failed to copy $FILE"
                echo "   ✅ File copied: $(basename "$FILE")"
            fi
        done
    fi

    # Copy directories (recursive)
    if compgen -G "$MODULE_DIR"*/ >/dev/null; then
        for DIR in "$MODULE_DIR"*/; do
            if [ -d "$DIR" ]; then
                cp -ru "$DIR" "$SHARED_DIR/" || echo "⚠️ Failed to copy dir $DIR"
                echo "   ✅ Directory copied: $(basename "$DIR")"
            fi
        done
    fi
done

# Copy module root files (e.g., package.json, requirements.txt, scripts)
ROOT_FILES=("package.json" "package-lock.json" "requirements.txt" "jupyter_setup.sh")
for FILE in "${ROOT_FILES[@]}"; do
    if [ -f "$FILE" ]; then
        cp -u "$FILE" "$SHARED_DIR/" || echo "⚠️ Failed to copy root file $FILE"
        echo "   ✅ Root file copied: $FILE"
    fi
done

echo "🔍 Verifying shared folder contents..."
ls -l "$SHARED_DIR"

echo "✅ Shared folder updated successfully!"
