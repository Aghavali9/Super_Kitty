#!/usr/bin/env bash
# install.sh - Bootstrap script to install stow and symlink dotfiles

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing dotfiles from $DOTFILES_DIR"

# Install GNU Stow if not already installed
if ! command -v stow &>/dev/null; then
  echo "==> stow not found, installing..."
  if command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y stow
  elif command -v brew &>/dev/null; then
    brew install stow
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm stow
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y stow
  else
    echo "ERROR: Could not find a supported package manager to install stow." >&2
    exit 1
  fi
else
  echo "==> stow is already installed"
fi

# Ensure ~/.local/bin exists (for scripts)
mkdir -p "$HOME/.local/bin"

# Stow each package into the home directory
PACKAGES=(zsh config scripts)

for pkg in "${PACKAGES[@]}"; do
  if [ -d "$DOTFILES_DIR/$pkg" ]; then
    echo "==> Stowing $pkg..."
    stow --restow --dir="$DOTFILES_DIR" --target="$HOME" "$pkg"
  else
    echo "WARNING: Package directory '$pkg' not found, skipping." >&2
  fi
done

echo "==> Done! Dotfiles installed successfully."
