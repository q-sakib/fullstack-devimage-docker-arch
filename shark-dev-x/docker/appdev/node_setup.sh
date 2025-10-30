#!/usr/bin/env bash
set -euo pipefail
echo "⚙️ Installing Node.js (NVM)..."

NVM_DIR="$HOME/.nvm"
export NVM_DIR

if [ ! -d "$NVM_DIR" ]; then
  mkdir -p "$NVM_DIR"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

source "$NVM_DIR/nvm.sh"

nvm install --lts
nvm alias default 'lts/*'
nvm use default

# Global developer tools
npm install -g yarn @angular/cli create-react-app create-next-app expo-cli ionic

echo "✅ Node.js setup complete!"
