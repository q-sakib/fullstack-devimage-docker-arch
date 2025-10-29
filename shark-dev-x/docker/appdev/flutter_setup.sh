#!/bin/bash
set -e

echo "🚀 Installing Flutter SDK..."

FLUTTER_DIR="$HOME/flutter"
if [ ! -d "$FLUTTER_DIR" ]; then
  git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

echo "✅ Flutter installed at: $FLUTTER_DIR"
flutter doctor
