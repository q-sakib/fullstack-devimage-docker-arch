#!/usr/bin/env bash
set -euo pipefail
echo "📦 Installing Android SDK..."

ANDROID_HOME="/opt/android-sdk"
CMDLINE_VERSION="11076708"

mkdir -p "$ANDROID_HOME/cmdline-tools"
wget -q "https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_VERSION}_latest.zip" -O /tmp/cmdline-tools.zip

unzip -q /tmp/cmdline-tools.zip -d "$ANDROID_HOME/cmdline-tools"
mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
rm /tmp/cmdline-tools.zip

chown -R devuser:devuser "$ANDROID_HOME"

export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

yes | sdkmanager --licenses || true
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "cmdline-tools;latest"

echo "✅ Android SDK setup complete!"
