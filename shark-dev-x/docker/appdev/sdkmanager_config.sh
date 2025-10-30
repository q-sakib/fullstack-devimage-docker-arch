#!/usr/bin/env bash
set -euo pipefail

echo "⚙️ Preconfiguring Android SDK packages for caching..."

ANDROID_HOME="/opt/android-sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# Define core SDK components (update as needed)
SDK_PACKAGES=(
  "platform-tools"
  "platforms;android-34"
  "build-tools;34.0.0"
  "cmdline-tools;latest"
  "sources;android-34"
  "system-images;android-34;google_apis;x86_64"
  "emulator"
)

# Accept all licenses silently
yes | sdkmanager --licenses || true

# Install or update packages (cached layer)
for pkg in "${SDK_PACKAGES[@]}"; do
  echo "📦 Installing $pkg..."
  sdkmanager "$pkg" || echo "⚠️ Failed to install $pkg"
done

# Optional: create an AVD image for emulator testing
if command -v avdmanager &>/dev/null; then
  echo "📱 Creating default AVD..."
  echo "no" | avdmanager create avd -n default -k "system-images;android-34;google_apis;x86_64" --force || true
fi

# Cleanup to reduce image size
rm -rf "$ANDROID_HOME/.android/avd" || true
rm -rf "$HOME/.android" || true

echo "✅ Android SDK preconfiguration complete!"
