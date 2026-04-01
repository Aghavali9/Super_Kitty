#!/bin/bash

# Resolves the absolute path of the repository root, assuming this script is inside it
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Use XDG_CONFIG_HOME if defined, otherwise fallback to standard ~/.config
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "Syncing system dotfiles to local repository at $REPO_DIR..."

# Sync function for directories
sync_dir() {
    local src="$1"
    local dest="$2"

    # Ensure destination exists
    mkdir -p "$dest"

    if [ -d "$src" ]; then
        # rsync -a (archive mode), -v (verbose), --delete (removes deleted source files from dest)
        # Note the trailing slashes: they ensure contents are synced, not the directory itself
        rsync -av --delete "$src/" "$dest/"
    else
        echo "[-] Source directory not found, skipping: $src"
    fi
}

# Sync function for standalone files
sync_file() {
    local src="$1"
    local dest="$2"

    mkdir -p "$dest"

    if [ -f "$src" ]; then
        cp "$src" "$dest"
        echo "Copied $src -> $dest"
    else
        echo "[-] Source file not found, skipping: $src"
    fi
}

echo "--- Syncing config/ ---"
sync_dir "$CONFIG_DIR/eza" "$REPO_DIR/config/eza"
sync_dir "$CONFIG_DIR/kitty" "$REPO_DIR/config/kitty"

# Starship logic (handles both directory and standalone toml file structures)
if [ -d "$CONFIG_DIR/starship" ]; then
    sync_dir "$CONFIG_DIR/starship" "$REPO_DIR/config/starship"
else
    sync_file "$CONFIG_DIR/starship.toml" "$REPO_DIR/config/starship"
fi

echo "--- Syncing git/ ---"
if [ -d "$CONFIG_DIR/git" ]; then
    sync_dir "$CONFIG_DIR/git" "$REPO_DIR/git"
else
    sync_file "$HOME/.gitconfig" "$REPO_DIR/git"
fi

echo "--- Syncing tmux/ ---"
if [ -d "$CONFIG_DIR/tmux" ]; then
    sync_dir "$CONFIG_DIR/tmux" "$REPO_DIR/tmux"
else
    sync_file "$HOME/.tmux.conf" "$REPO_DIR/tmux"
fi

echo "--- Syncing zsh/ ---"
if [ -d "$CONFIG_DIR/zsh" ]; then
    sync_dir "$CONFIG_DIR/zsh" "$REPO_DIR/zsh"
else
    sync_file "$HOME/.zshrc" "$REPO_DIR/zsh"
    sync_file "$HOME/.zshenv" "$REPO_DIR/zsh"
fi

echo "--- Syncing scripts/ ---"
# Assuming your custom scripts are kept in a local bin or a home scripts folder
sync_file "$HOME/scripts/my_custom_script.sh" "$REPO_DIR/scripts"

echo -e "\nUpdate complete. Run 'git status' to review changes."
