#!/usr/bin/env bash
set -euo pipefail
echo "🚀 Installing Flutter SDK..."

FLUTTER_DIR="/opt/flutter"

if [ ! -d "$FLUTTER_DIR" ]; then
  git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

# Cache Flutter binaries and enable platforms
flutter doctor -v || true
flutter precache
flutter config --enable-web
flutter config --enable-linux-desktop
flutter config --enable-macos-desktop || true
flutter config --enable-windows-desktop || true

echo "✅ Flutter setup complete!"
