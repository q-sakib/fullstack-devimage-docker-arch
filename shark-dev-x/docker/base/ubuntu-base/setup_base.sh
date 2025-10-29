#!/bin/bash
set -e

echo "🔧 Running base setup for Ubuntu..."

# Upgrade pip & install global python helpers
sudo python3 -m pip install --upgrade pip setuptools wheel virtualenv

# Configure zsh for the user
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🌀 Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Setup zsh as default shell
chsh -s $(which zsh)

echo "✅ Ubuntu base setup complete."
