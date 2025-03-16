#!/bin/bash

# Creates a symlink, keeping a backup if a file previously existed
symlink() {
  if [[ -e "$2" ]]; then
    if [[ -L "$2" ]]; then
      echo "Existing symlink found at $2, deleting..."
      rm -f "$2"
    else
      echo "Existing file or directory found at $2, creating backup..."
      mv -f "$2" "${2}_$(date +%s).bak"
    fi
  fi

  echo "Creating symlink to $1 at $2..."
  ln -sf "$1" "$2"
}

# Create config directory
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
if [[ ! -d "$CONFIG" ]]; then
  echo "Config directory not found, creating..."
  mkdir -p "$CONFIG"
fi

# Create symlinks for zsh
symlink "$PWD/zsh/.zshrc" "$HOME/.zshrc"
symlink "$PWD/zsh/.zimrc" "$HOME/.zimrc"

# Create symlinks for tmux
symlink "$PWD/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Create symlinks for git
symlink "$PWD/git/.gitconfig" "$HOME/.gitconfig"

# Create symlinks for nvim
symlink "$PWD/nvim" "$CONFIG/nvim"
