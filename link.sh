#!/bin/bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

backup_and_link() {
  local src=$1
  local dest=$2

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Backing up existing $dest to ${dest}.backup"
    mv "$dest" "${dest}.backup"
  fi

  ln -sf "$src" "$dest"
  echo "Linked $dest -> $src"
}

# Files/folders to put directly in home (except .ssh/config handled separately)
home_items=(
  ".bashrc"
  ".clang-format"
  ".gitconfig"
  ".gitignore"
  ".pylintrc"
  ".zshrc"
)

# Folders to put inside ~/.config
config_items=(
  "nvim"
  "tmux"
  "ghostty"
)

# Ensure ~/.config exists
mkdir -p "$CONFIG_DIR"

# Symlink files/folders directly in home
for item in "${home_items[@]}"; do
  backup_and_link "$DOTFILES_DIR/$item" "$HOME/$item"
done

# Handle .ssh/config file separately
mkdir -p "$HOME/.ssh" 2> /dev/null
backup_and_link "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"

# Symlink config folders in ~/.config
for item in "${config_items[@]}"; do
  backup_and_link "$DOTFILES_DIR/$item" "$CONFIG_DIR/$item"
done

echo "All dotfiles symlinked successfully!"

