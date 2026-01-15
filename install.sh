#!/bin/bash
# Win98 Rice Installation Script using GNU Stow

set -e

echo "Installing Win98 Rice dotfiles with Stow..."

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "GNU Stow not found. Install with: sudo pacman -S stow"
    exit 1
fi

# Get script directory
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

# Create config directory if needed
mkdir -p ~/.config

# Stow all packages
stow -v -t ~ hypr
stow -v -t ~ waybar
stow -v -t ~ tofi
stow -v -t ~ kitty
stow -v -t ~ gtk

# Apply gsettings
gsettings set org.gnome.desktop.interface gtk-theme 'Chicago95'
gsettings set org.gnome.desktop.interface icon-theme 'Chicago95'
gsettings set org.gnome.desktop.interface cursor-theme 'Chicago95_Cursor_White'
gsettings set org.gnome.desktop.interface font-name 'Terminess Nerd Font 10'

echo ""
echo "Done! Next steps:"
echo "  1. Enable hyprbars plugin: hyprpm enable hyprbars"
echo "  2. Edit monitor/wallpaper configs for your device"
echo "  3. Reload Hyprland: hyprctl reload"
