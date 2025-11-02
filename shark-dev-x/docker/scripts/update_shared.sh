# scripts/update_shared.sh
#!/usr/bin/env bash
set -e

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

    echo "➡ Processing $MODULE_NAME..."

    # Copy all files (non-recursive) in the module folder
    for FILE in "$MODULE_DIR"*; do
        if [ -f "$FILE" ]; then
            cp -u "$FILE" "$SHARED_DIR/"
            echo "   ✅ File copied: $(basename "$FILE")"
        fi
    done

    # Copy all directories in the module folder
    for DIR in "$MODULE_DIR"*/; do
        if [ -d "$DIR" ]; then
            cp -ru "$DIR" "$SHARED_DIR/"
            echo "   ✅ Directory copied: $(basename "$DIR")"
        fi
    done
done

echo "🔍 Verifying shared folder contents..."
ls -l "$SHARED_DIR"

echo "✅ Shared folder updated successfully!"
