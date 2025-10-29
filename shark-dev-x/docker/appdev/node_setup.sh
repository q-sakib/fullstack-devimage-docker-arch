#!/bin/bash
set -e

echo "🟢 Installing Node.js via NVM..."

export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source "$NVM_DIR/nvm.sh"

nvm install --lts
nvm alias default lts/*
nvm use default

npm install -g yarn pnpm @angular/cli create-next-app expo-cli

echo "✅ Node.js $(node -v), npm $(npm -v), yarn $(yarn -v)"
