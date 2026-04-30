#!/usr/bin/env bash

set -e

DOTFILES="$HOME/dotfiles"

PACKAGES=(
  nvim
  zsh
  waybar
  wofi
  hyprland
  hyprlauncher
)

echo "🔍 Dry run..."
for pkg in "${PACKAGES[@]}"; do
  echo ""
  echo "==> $pkg"
  rsync -avh --dry-run "$DOTFILES/$pkg/" "$HOME/"
done

echo ""
read -p "Proceed with syncing? (y/n): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "❌ Cancelled"
  exit 0
fi

for pkg in "${PACKAGES[@]}"; do
  echo ""
  echo "==> Syncing $pkg"
  rsync -avh "$DOTFILES/$pkg/" "$HOME/"
done

echo ""
echo "✅ Done syncing dotfiles!"
