#!/usr/bin/env bash
set -euo pipefail

# GNU Stow installer for this dotfiles repo.
# Symlinks each package from ~/dotfiles into ~/.config.
#
# Usage:
#   ./install.sh            link packages (idempotent)
#   ./install.sh -D         unlink packages
#   ./install.sh --uninstall  (same as -D)

cd "$(dirname "$0")"

TARGET="$HOME"
PACKAGES=(nvim yazi tmux fastfetch ghostty)

if ! command -v stow >/dev/null 2>&1; then
  echo "error: GNU stow is not installed." >&2
  echo "Install it with your package manager, e.g.:" >&2
  echo "  macOS (Homebrew): brew install stow" >&2
  echo "  Debian/Ubuntu:    sudo apt install stow" >&2
  echo "  Arch:             sudo pacman -S stow" >&2
  echo "  Fedora:           sudo dnf install stow" >&2
  exit 1
fi

mkdir -p "$TARGET"

if [ "${1:-}" = "-D" ] || [ "${1:-}" = "--uninstall" ]; then
  echo "Unlinking packages from $TARGET ..."
  stow -D --target="$TARGET" "${PACKAGES[@]}"
else
  echo "Linking packages into $TARGET ..."
  stow --target="$TARGET" "${PACKAGES[@]}"
fi

echo "Done."
