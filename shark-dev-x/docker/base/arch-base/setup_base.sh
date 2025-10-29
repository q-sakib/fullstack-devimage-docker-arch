#!/bin/bash
set -e

echo "🔧 Running base setup for Arch Linux..."

# Upgrade pip & install Python helpers
python -m pip install --upgrade pip setuptools wheel virtualenv

# Load shared env and aliases if present
if [ -f "/tmp/common_env.sh" ]; then
    echo "📁 Loading common environment..."
    echo "source /tmp/common_env.sh" >> ~/.zshrc
fi

if [ -f "/tmp/zsh_aliases" ]; then
    echo "📁 Loading zsh aliases..."
    echo "source /tmp/zsh_aliases" >> ~/.zshrc
fi

# Install oh-my-zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🌀 Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Set default shell
chsh -s $(which zsh)

echo "✅ Arch base setup complete."
