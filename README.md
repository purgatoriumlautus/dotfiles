# Win98 Rice - Hyprland Dotfiles

A minimalist Windows 98 inspired rice for Hyprland on Arch Linux.

## Screenshot

<!-- Add screenshot here -->

## Components

| Component | Tool |
|-----------|------|
| Compositor | Hyprland |
| Window Title Bars | hyprbars plugin |
| Wallpaper | Hyprpaper |
| Bar | Waybar |
| Launcher | Tofi |
| Terminal | Kitty |
| Terminal Multiplexer | tmux |
| Editor | Neovim |
| File Manager | Thunar |
| Image Viewer | gpicview |
| Video Player | mpv |
| Display Manager | Ly |
| Clipboard | cliphist + wl-clipboard |
| Calendar | gsimplecal |
| Network Manager | nm-connection-editor |
| Bluetooth | blueman |
| Screenshots | grim + slurp + swappy |
| Power Menu | tofi (script) |
| Screen Recording | wf-recorder |
| Notifications | mako |
| Night Light | hyprsunset |
| GTK Theme | Chicago95 |
| Icons | Chicago95 |
| Cursors | Chicago95_Cursor_White |
| Font | Terminess Nerd Font |

## Structure

```
dotfiles/
├── hypr/.config/hypr/          → Hyprland, hyprpaper, hyprsunset, scripts
├── waybar/.config/waybar/      → Bar config and styling
├── tofi/.config/tofi/          → App launcher
├── kitty/.config/kitty/        → Terminal
├── tmux/.config/tmux/          → Terminal multiplexer
├── mako/.config/mako/          → Notifications
├── nvim/.config/nvim/          → Editor
├── zsh/.zshrc                  → Shell config (stows to ~/)
├── gtk/.config/gtk-*/          → GTK theming
├── xfce4/.config/xfce4/        → Thunar helpers (terminal = kitty)
├── swappy/.config/swappy/      → Screenshot editor
├── ly/                         → Display manager (system config, manual copy)
├── grub/                       → GRUB theme (system config, manual copy)
└── README.md
```

**Note:** `ly/` and `grub/` contain system-level configs that can't be stowed. See [System Configs](#system-configs) for installation.

## Dependencies

```bash
# Core
sudo pacman -S hyprland hyprpaper waybar kitty thunar tofi stow neovim tmux

# Clipboard
sudo pacman -S wl-clipboard cliphist

# Display manager
sudo pacman -S ly

# Hyprbars plugin (window title bars — part of hyprland-plugins)
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprbars

# Network manager GUI
sudo pacman -S networkmanager nm-connection-editor

# Bluetooth (laptop)
sudo pacman -S bluez bluez-utils blueman

# Night light
sudo pacman -S hyprsunset

# Audio/video
sudo pacman -S pavucontrol playerctl mpv

# Image viewer
sudo pacman -S gpicview

# Calendar
sudo pacman -S gsimplecal

# Screenshots
sudo pacman -S grim slurp swappy

# Screen recording & notifications
sudo pacman -S wf-recorder mako libnotify

# Brightness control
sudo pacman -S brightnessctl

# Theming
yay -S chicago95-gtk-theme-git chicago95-icon-theme-git xcursor-chicago95-git

# Fonts (browser symbols + terminal)
sudo pacman -S ttf-terminus-nerd noto-fonts-emoji noto-fonts-cjk

# Optional
sudo pacman -S tumbler ffmpegthumbnailer  # thumbnails
```

## Installation

```bash
git clone https://github.com/purgatoriumlautus/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Stow all user configs (excludes ly/ and grub/)
stow hypr waybar tofi kitty tmux mako nvim gtk xfce4 swappy zsh
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
| `Super + Shift + E` | Power menu (sleep, logout, reboot, shutdown) |
| `Super + \` | Clipboard history |
| `Super + H/J/K/L` | Focus window |
| `Super + Shift + H/J/K/L` | Move window |
| `Super + Ctrl + H/J/K/L` | Move window into group |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + G` | Toggle group |
| `Super + Shift + G` | Move window out of group |
| `Super + Tab` | Cycle group windows forward |
| `Super + Shift + Tab` | Cycle group windows backward |
| `Print` | Screenshot region → swappy → file + clipboard |
| `Shift + Print` | Screenshot fullscreen → swappy → file + clipboard |
| `Super + Print` | Toggle screen recording |
| `Super + Shift + Print` | Toggle region recording |
| `Super + \`` | Enter VM passthrough mode (only Super+* keys work) |
| `Mod + Left drag` | Move window |
| `Mod + Right drag` | Resize window |
| `XF86 keys` | Brightness, volume, media |

## Waybar Click Actions

| Module | Click Action |
|--------|--------------|
| Bluetooth | Toggle blueman-manager |
| Network | Toggle nm-connection-editor |
| Pulseaudio | Toggle pavucontrol |
| Clock | Open gsimplecal calendar |

## Neovim Keybinds

### General

| Key | Action |
|-----|--------|
| `\n` | Toggle file tree |
| `\e` | Toggle focus (tree ↔ file) |
| `\1-9` | Go to tab 1-9 |
| `\0` | Go to last tab |
| `Ctrl+a` | Select all |
| `Esc` | Clear search highlight |
| `:Q` | Quit all (no save) |
| `:WQ` | Save all + quit |

### File Tree (nvim-tree)

| Key | Action |
|-----|--------|
| `h` | Close folder / go up |
| `l` | Open folder / open file |
| `H` | Change root to parent |
| `L` | Change root to selected dir |
| `Enter` | Open in new tab (stay in tree) |
| `o` | Open in current tab |
| `Ctrl+v` | Open in vertical split |
| `Ctrl+h` | Open in horizontal split |
| `a` | Create file/folder |
| `d` | Delete |
| `r` | Rename |
| `g?` | Show all keybinds |

### Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `\ff` | Find files |
| `\fg` | Grep in project |
| `\fb` | Open buffers |
| `\fr` | Recent files |
| `\fh` | Search help |
| `Enter` | Open in new tab |
| `Ctrl+v` | Open in vertical split |
| `Ctrl+h` | Open in horizontal split |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `\rn` | Rename symbol |
| `\ca` | Code actions |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Git (gitsigns)

| Key | Action |
|-----|--------|
| `]c` | Next change (hunk) |
| `[c` | Previous change |
| `\hp` | Preview hunk |
| `\hr` | Reset hunk |
| `\hb` | Blame line |

## Tmux Keybinds

### Navigation

| Key | Action |
|-----|--------|
| `Alt+h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl+Alt+h/j/k/l` | Resize panes |
| `Alt+1-9` | Switch to window 1-9 |

### Windows & Panes

| Key | Action |
|-----|--------|
| `Alt+\` | Vertical split |
| `Alt+-` | Horizontal split |
| `Alt+Enter` | New window |
| `Alt+c` | Kill pane |
| `Alt+q` | Kill window |

### Sessions

| Key | Action |
|-----|--------|
| `Alt+d` | Detach |
| `Alt+s` | Session picker |
| `Alt+n` | New session |
| `Alt+Q` | Kill session (confirm) |

### Other

| Key | Action |
|-----|--------|
| `Alt+z` | Copy mode |
| `Alt+/` | Search down |
| `Alt+?` | Search up |
| `Alt+r` | Reload config |

## Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Silver | `#c0c0c0` | Background, title bars |
| Grey | `#808080` | Borders, inactive |
| Navy | `#000080` | Accent, active workspace, title text |
| White | `#ffffff` | Text on accent |
| Black | `#000000` | Text |

## Multi-Device Setup

### Monitors & Wallpapers
Monitor and wallpaper configs are commented out by default. After installing:

```bash
# Find your monitor names
hyprctl monitors

# Edit configs
nvim ~/.config/hypr/hyprland.conf    # Uncomment/edit monitor lines
nvim ~/.config/hypr/hyprpaper.conf   # Uncomment/edit wallpaper lines
```

### Battery (Waybar)
Edit `waybar/.config/waybar/config.jsonc` - change `"bat": "BAT1"` to match your device:
- Laptop: usually `BAT0` or `BAT1`
- Desktop: remove battery module from `modules-right`

### Bluetooth (Laptop only)
Comment out in `hyprland.conf` on desktop:
```bash
# exec-once = blueman-applet
```

### Brightness Keys
The brightness binds use `nv_backlight` (NVIDIA laptop). Change in `hyprland.conf`:
```bash
# For other devices, find your backlight:
ls /sys/class/backlight/
# Then update the brightnessctl -d parameter
```

## Ly Display Manager

Ly config is at `/etc/ly/config.ini` (requires sudo). Key settings:
```ini
# Laptop
battery_id = BAT1

# Auto-login to Hyprland
auto_login_session = hyprland

# Customizations
animation = colormix
vi_mode = true
clock = %c
```

## System Configs

These configs require root and can't be stowed to home. Copy manually.

### GRUB Theme (Shodan)

```bash
# Copy theme to grub themes directory
sudo cp -r ~/dotfiles/grub/Shodan /boot/grub/themes/

# Edit grub config
sudo nvim /etc/default/grub
# Add/edit: GRUB_THEME="/boot/grub/themes/Shodan/theme.txt"

# Regenerate grub config
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Ly Display Manager

```bash
# Copy config (backup existing first)
sudo cp /etc/ly/config.ini /etc/ly/config.ini.bak
sudo cp ~/dotfiles/ly/etc/ly/config.ini /etc/ly/config.ini

# Or edit manually - key settings in ly/ folder
```

## Security

SSH is installed but disabled. No firewall configured. No services exposed to the network.

## Uninstall

```bash
cd ~/dotfiles  # or wherever you cloned
stow -D hypr waybar tofi kitty tmux mako nvim gtk xfce4 swappy zsh
```
