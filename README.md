# Win98 Rice - Hyprland Dotfiles

Minimalist Windows 98 rice for Hyprland on Arch Linux. Personal config for magi (laptop).

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
| Shell | zsh |
| Editor | Neovim |
| File Manager | Thunar |
| Image Viewer | Nomacs |
| Display Manager | Ly |
| Clipboard | cliphist + wl-clipboard |
| Screenshots | grim + slurp + satty |
| Notifications | mako |
| Night Light | hyprsunset |
| Audio | PipeWire + WirePlumber + pavucontrol |
| DNS | dnscrypt-proxy (encrypted DoH + ad-blocking) |
| Firewall | nftables |
| Power | TLP |
| VMs | QEMU/KVM + libvirt + virt-manager |
| Containers | Docker (rootless, manual start) |
| GTK Theme | Chicago95 |
| Icons | Chicago95 |
| Cursors | Chicago95_Cursor_White |
| Font | Terminess Nerd Font (GTK) / Unifont (terminal) |

## Structure

```
dotfiles/
├── grub/           → /boot/grub/themes/ (manual copy)
├── gtk/            → ~/.config/gtk-{2.0,3.0,4.0}/
├── hypr/           → ~/.config/hypr/
├── kitty/          → ~/.config/kitty/
├── ly/             → /etc/ly/ (manual copy)
├── mako/           → ~/.config/mako/
├── nftables/       → /etc/nftables.conf (manual copy)
├── nvim/           → ~/.config/nvim/
├── sysctl/         → /etc/sysctl.d/ (manual copy)
├── tmux/           → ~/.config/tmux/
├── tofi/           → ~/.config/tofi/
├── waybar/         → ~/.config/waybar/
├── xfce4/          → ~/.config/xfce4/
└── zsh/            → ~/
```

System-level configs (grub, ly, nftables, sysctl) require sudo and manual copy.

## Hyprland Keybinds

| Key | Action |
|-----|--------|
| `Super + Return` | Terminal |
| `Super + D` | App launcher |
| `Super + E` | File manager |
| `Super + Q` | Close window |
| `Super + F` | Maximize |
| `Super + V` | Toggle floating |
| `Super + H/J/K/L` | Focus window |
| `Super + Shift + H/J/K/L` | Move window |
| `Super + Ctrl + H/J/K/L` | Move into group |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move to workspace |
| `Super + G` | Toggle group |
| `Super + Tab / Shift+Tab` | Cycle group windows |
| `Super + \` | Clipboard history |
| `Super + Shift + E` | Power menu |
| `Super + \`` | VM passthrough mode |
| `Print` | Screenshot region (satty) |
| `XF86 keys` | Volume, brightness, media |

## Tmux Keybinds

| Key | Action |
|-----|--------|
| `Alt + h/j/k/l` | Navigate panes |
| `Ctrl+Alt + h/j/k/l` | Resize panes |
| `Alt + 1-9` | Switch window |
| `Alt + \` | Vertical split |
| `Alt + -` | Horizontal split |
| `Alt + Enter` | New window |
| `Alt + c` | Kill pane |
| `Alt + q` | Kill window |
| `Alt + d` | Detach |
| `Alt + s` | Session picker |
| `Alt + z` | Copy mode |
| `Alt + r` | Reload config |

## Neovim Keybinds

| Key | Action |
|-----|--------|
| `\n` | Toggle file tree |
| `\e` | Toggle focus (tree / file) |
| `\1-9` | Go to tab |
| `\ff` | Find files |
| `\fg` | Grep in project |
| `\fb` | Open buffers |
| `\fr` | Recent files |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover docs |
| `\rn` | Rename symbol |
| `]c / [c` | Next/prev git change |
| `\hp` | Preview hunk |
| `ys<motion><char>` | Add surrounding (e.g. `ysiw(` wraps word in parens) |
| `cs<old><new>` | Change surrounding (e.g. `cs"'` changes double to single quotes) |
| `ds<char>` | Delete surrounding (e.g. `ds(` removes parens) |
| `S<char>` | Surround selection (visual mode) |

## Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Silver | `#c0c0c0` | Background, title bars |
| Grey | `#808080` | Borders, inactive |
| Navy | `#000080` | Accent, active workspace |
| White | `#ffffff` | Text on accent |
| Black | `#000000` | Text |
