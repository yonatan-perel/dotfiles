#!/bin/bash
set -e

ZSH_DIR="$HOME/.config/zsh"
PLUGIN_DIR="$ZSH_DIR/plugins"
mkdir -p "$PLUGIN_DIR"

# Symlink .zshrc
if [ ! -L "$HOME/.zshrc" ]; then
  ln -sf "$ZSH_DIR/.zshrc" "$HOME/.zshrc"
  echo "Symlinked .zshrc"
fi

# Clone plugins
if [ ! -d "$PLUGIN_DIR/fzf-tab" ]; then
  git clone https://github.com/Aloxaf/fzf-tab "$PLUGIN_DIR/fzf-tab"
fi

if [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR/zsh-autosuggestions"
fi

echo "Done!"
