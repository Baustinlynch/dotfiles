#!/run/current-system/sw/bin/sh
# Copy Obsidian CSS snippet into the vault on each graphical session start.
# Idempotent: safe to run multiple times. Survives NixOS rebuilds because the
# source lives in dotfiles/.
set -eu

VAULT="$HOME/Documents/Obsidian/.obsidian/snippets"
SRC="/home/brenden/nixos-config/dotfiles/obsidian/transparent-ui.css"

mkdir -p "$VAULT"
cp -f "$SRC" "$VAULT/transparent-ui.css"
