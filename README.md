# Win98 Rice - Hyprland Dotfiles

A minimalist Windows 98 inspired rice for Hyprland on Arch Linux.

## Screenshot

<!-- Add screenshot here -->

## Components

| Component | Tool |
|-----------|------|
| Compositor | Hyprland |
| Bar | Waybar |
| Launcher | Tofi |
| Terminal | Kitty |
| File Manager | Thunar |
| GTK Theme | Chicago95 |
| Icons | Chicago95 |
| Cursors | Chicago95_Cursor_White |
| Font | Terminess Nerd Font |

## Structure

```
dotfiles/
├── hypr/.config/hypr/hyprland.conf
├── waybar/.config/waybar/{config.jsonc,style.css}
├── tofi/.config/tofi/config
├── kitty/.config/kitty/kitty.conf
├── gtk/.config/gtk-{2.0,3.0,4.0}/...
├── install.sh
└── README.md
```

## Dependencies

```bash
# Core
sudo pacman -S hyprland waybar kitty thunar tofi stow

# Theming
yay -S chicago95-gtk-theme-git chicago95-icon-theme-git xcursor-chicago95-git

# Font
sudo pacman -S ttf-terminus-nerd

# Optional
sudo pacman -S tumbler ffmpegthumbnailer  # thumbnails
```

## Installation

### Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Manual with Stow

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Stow individual packages
stow hypr      # Hyprland config
stow waybar    # Bar
stow tofi      # Launcher
stow kitty     # Terminal
stow gtk       # All GTK theming

# Or stow everything
stow */
```

### Apply GTK Theme

```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Chicago95'
gsettings set org.gnome.desktop.interface icon-theme 'Chicago95'
gsettings set org.gnome.desktop.interface cursor-theme 'Chicago95_Cursor_White'
gsettings set org.gnome.desktop.interface font-name 'Terminess Nerd Font 10'
```

### Reload

```bash
hyprctl reload
```

## Keybinds

| Key | Action |
|-----|--------|
| `Super + Return` | Terminal |
| `Super + D` | App launcher |
| `Super + E` | File manager |
| `Super + Q` | Close window |
| `Super + F` | Maximize window |
| `Super + V` | Toggle floating |
| `Super + H/J/K/L` | Focus window |
| `Super + Shift + H/J/K/L` | Move window |
| `Super + 1-9` | Switch workspace |
| `Super + G` | Toggle group |
| `Super + Tab` | Cycle group windows |

## Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Silver | `#c0c0c0` | Background |
| Grey | `#808080` | Borders, inactive |
| Navy | `#000080` | Accent, selection |
| White | `#ffffff` | Text on accent |
| Black | `#000000` | Text |

## Uninstall

```bash
cd ~/dotfiles
stow -D hypr waybar tofi kitty gtk
```
