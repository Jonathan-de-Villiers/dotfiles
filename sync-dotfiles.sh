#!/usr/bin/env bash

set -e

DOTFILES="$HOME/dotfiles"

# Identify packages: all directories in $DOTFILES that don't start with .
ALL_PACKAGES=()
for d in "$DOTFILES"/*/; do
    [ -d "$d" ] || continue
    pkg=$(basename "$d")
    # Skip hidden directories
    [[ "$pkg" =~ ^\. ]] && continue
    ALL_PACKAGES+=("$pkg")
done

if [ -n "$1" ]; then
  # Check if requested package exists
  found=false
  for pkg in "${ALL_PACKAGES[@]}"; do
    if [ "$pkg" == "$1" ]; then
      found=true
      break
    fi
  done

  if [ "$found" = false ]; then
    echo "❌ Error: Package '$1' not found."
    echo "Available packages: ${ALL_PACKAGES[*]}"
    exit 1
  fi
  PACKAGES=("$1")
else
  PACKAGES=("${ALL_PACKAGES[@]}")
fi

echo "📦 Selected packages: ${PACKAGES[*]}"

echo "🔍 Dry run (listing files)..."
for pkg in "${PACKAGES[@]}"; do
  echo ""
  echo "==> $pkg"
  find "$DOTFILES/$pkg" -maxdepth 2 -not -path '*/.*'
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
  
  # Remove existing symlinks in the target to avoid "same file" errors
  # and allow replacement with actual files.
  cd "$DOTFILES/$pkg"
  find . -type f -o -type d | while read rel; do
    dst="$HOME/$rel"
    if [ -L "$dst" ]; then
      echo "  Removing symlink: $dst"
      rm "$dst"
    fi
  done
  
  cp -avT "$DOTFILES/$pkg/" "$HOME/"
done

echo ""
echo "✅ Done syncing dotfiles!"
