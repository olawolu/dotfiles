#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.config/ghostty" "$HOME/.config/ghostty/config"

echo "Dotfiles linked."
