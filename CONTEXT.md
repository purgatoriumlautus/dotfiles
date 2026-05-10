# System Context — magi

System manifest for Claude. Static snapshot, manually maintained.

**Last verified: 2026-04-04**

## Philosophy

**Performance-driven minimalism.** Every choice optimizes for:
1. **Responsiveness** — system should feel instant
2. **Minimal footprint** — fewest packages possible
3. **Unix philosophy** — one tool, one job, done well

The Win98/Chicago95 aesthetic is a side effect, not the goal. Lightweight interfaces happen to look retro.

### Why Wayland

- Simpler architecture than X11
- Better documentation
- More secure (isolation by default)
- Industry direction — everything is moving here

## Hardware

| Component | Value |
|-----------|-------|
| Hostname | magi |
| CPU | Intel Core i5-7300HQ @ 2.50GHz (4C/4T, turbo 3.5GHz) |
| RAM | 16GB DDR4 |
| GPU | NVIDIA GTX 1060 Mobile (nouveau) + Intel HD 630 (i915, unused) |
| Battery | ASUS A32-K55, 62.3% health (40.1Wh / 64.4Wh design) |
| Display | eDP-1, 1920x1080 @ 120Hz |
| Wifi | Intel Wireless 8265 |
| Bluetooth | Intel Corp, soft-blocked |
| Ethernet | Realtek RTL8111 Gigabit |

### Storage

| Device | Type | Size | Mount | Notes |
|--------|------|------|-------|-------|
| /dev/sda2 | btrfs | 119G | / | Root |
| /dev/sda1 | FAT32 | 1G | /boot | EFI boot |
| /dev/sdb1 | NTFS | 932G | — | "DATA" old Windows drive, planned btrfs reformat |
| zram0 | swap | 4G | [SWAP] | Compressed RAM swap |

### Btrfs Subvolumes

| Subvolume | Mount |
|-----------|-------|
| @ | / |
| @home | /home |
| @pkg | /var/cache/pacman/pkg |
| @log | /var/log |

Mount options: compress=zstd:3, ssd, discard=async, space_cache=v2

## Network

| Property | Value |
|----------|-------|
| Interface | wlan0 (wifi), enp2s0 (ethernet, unused) |
| NM backend | iwd |
| DNS | 127.0.0.1 (dnscrypt-proxy — encrypted DoH, ad-blocking) |
| NM dns | none (dnscrypt-proxy owns /etc/resolv.conf) |

No wired connection in regular use.

## Services

### Running

| Service | Description |
|---------|-------------|
| dnscrypt-proxy | Encrypted DNS resolver with ad-blocking |
| iwd | Wireless daemon (NM backend) |
| keyd | Keyboard remapping (Feker Galaxy80 external keyboard) |
| ly@tty2 | TUI display manager |
| NetworkManager | Network management |
| nftables | Firewall (oneshot, rules loaded in kernel) |
| pipewire + wireplumber | Audio stack (user service) |
| tlp | Power management |
| dbus-broker | D-Bus message bus |
| polkit | Authorization manager |
| rtkit-daemon | Realtime scheduling for audio |
| systemd-timesyncd | NTP time sync |
| systemd-journald | System logging |
| systemd-logind | Login management |
| systemd-udevd | Device manager |
| upower | Power management |

### Enabled but not running

| Service | Description |
|---------|-------------|
| bluetooth | Bluetooth stack (soft-blocked, available when needed) |
| libvirtd | QEMU/KVM virtualization (socket-activated) |

### Disabled

| Service | Description |
|---------|-------------|
| docker (rootless) | Container runtime (manual start when needed) |
| systemd-resolved | Replaced by dnscrypt-proxy |
| systemd-rfkill | Masked (TLP manages radio state) |

## Security Posture

### Firewall (nftables)

- **Input policy:** drop (default deny)
- Allowed: established/related connections, loopback, ICMP, DHCP
- Log and drop everything else
- **Forward policy:** drop (no routing, rootless Docker doesn't use forward chain)
- **Output policy:** accept
- Config: `/etc/nftables.conf`

### sysctl Hardening

Config: `/etc/sysctl.d/99-hardening.conf`

| Setting | Value | Purpose |
|---------|-------|---------|
| kernel.kptr_restrict | 1 | Hide kernel pointers from non-root |
| net.ipv4.ip_forward | 0 | No forwarding (rootless Docker, no bridge) |
| net.ipv4.conf.all.rp_filter | 1 | Reverse path filtering (anti-spoof) |
| net.ipv4.conf.all.accept_redirects | 0 | Reject ICMP redirects |
| net.ipv4.conf.all.send_redirects | 0 | Don't send ICMP redirects |

### Other

- **SSH:** Disabled, not running
- **Listening ports:** 127.0.0.1:53 (dnscrypt-proxy)
- **faillock:** Active (default config)

## Installed Packages

### Core System

base, base-devel, linux, linux-firmware, intel-ucode, grub, efibootmgr, sudo

### Compositor / DE

hyprland, waybar, hyprpaper, hyprsunset, mako, tofi, xdg-desktop-portal, xdg-desktop-portal-hyprland

### Terminal / Shell / Editor

kitty, zsh, tmux, neovim

### File Management

thunar, tumbler, 7zip, unzip

### Media / Audio

pipewire, pipewire-alsa, pipewire-jack, pipewire-pulse, wireplumber, pavucontrol, nomacs

### Clipboard / Screenshots

wl-clipboard, cliphist, grim, slurp, satty

### Networking

networkmanager, iwd, dnscrypt-proxy

### Power Management

tlp

### Virtualization

qemu-full, libvirt, virt-manager, virt-viewer, spice, spice-gtk

### Dev Tools

git, npm, cmake, stow

### CLI Utilities

btop, fd, fzf, zoxide, dust, fastfetch, lsof, mandoc, pacman-contrib

### Fonts

otf-unifont, ttf-terminus-nerd, ttf-nerd-fonts-symbols, ttf-ms-fonts, noto-fonts, noto-fonts-cjk, noto-fonts-emoji

### Applications

firefox, libreoffice, pinta, gsimplecal

### Security

nftables

### AUR (foreign)

chicago95-gtk-theme-git, chicago95-icon-theme-git, xcursor-chicago95-git, tofi, nomacs, yay

### Runtime (not via pacman)

- **nvm:** Node v24 at ~/.nvm

## Stow Structure

```
~/dotfiles/
├── grub/           → /boot/grub/themes/ (reference only, manual copy)
├── gtk/            → ~/.config/gtk-{2.0,3.0,4.0}/
├── hypr/           → ~/.config/hypr/
├── kitty/          → ~/.config/kitty/
├── ly/             → /etc/ly/ (reference only, manual copy)
├── mako/           → ~/.config/mako/
├── nftables/       → /etc/nftables.conf (reference only)
├── nvim/           → ~/.config/nvim/
├── sysctl/         → /etc/sysctl.d/ (reference only)
├── tmux/           → ~/.config/tmux/
├── tofi/           → ~/.config/tofi/
├── waybar/         → ~/.config/waybar/
├── xfce4/          → ~/.config/xfce4/
└── zsh/            → ~/
```

**System-level (reference only, require sudo):** grub, ly, nftables, sysctl
**Stow-able (user-level):** everything else

## Compositor / DE

### Hyprland

- **Config:** `~/.config/hypr/hyprland.conf` (symlink from repo)
- **Layout:** dwindle (tiling)
- **Mod key:** SUPER
- **Monitor:** eDP-1, 1920x1080 @ 120Hz

### Autostart

waybar, hyprsunset, hyprpaper, mako, hyprpm reload, cliphist (text + image watchers)

### Key Bindings Philosophy

- Vim-style navigation (HJKL) everywhere
- SUPER + key for window management
- SUPER + SHIFT for moving windows
- SUPER + CTRL for grouping
- Alt+Shift toggles keyboard layout (US/RU/UA)
- VM passthrough submap (SUPER+`) — passes all keys to VM except SUPER+* binds

### Environment

- Cursor: Chicago95_Cursor_White, size 48
- GTK_THEME: Chicago95
- Animations: disabled
- Shadows: disabled
- Blur: disabled
- Border rounding: 0

## Shell / Terminal / Editor

### zsh

- **Config:** `~/.zshrc` (symlink from repo)
- Minimal, no framework (no oh-my-zsh)
- Vi mode with insert/normal indicator in prompt (I/N)
- Prompt: `[I/N] user@マギ ~/path (branch)` then `>` on next line
- Clipboard integration: Y/D/P in normal mode use wl-copy/wl-paste
- FZF: fd-backed, Ctrl+G for cd widget
- zoxide: `z` aliased to `cd`
- History: 10000 lines, shared between sessions, dedup
- Correction: enabled for commands and arguments
- NVM on PATH
- LIBVIRT_DEFAULT_URI set to qemu:///system

### kitty

- **Config:** `~/.config/kitty/kitty.conf` (symlink from repo)
- Font: Unifont (intentional — different from celestia's Terminess Nerd Font)
- Theme: Gruvbox Dark
- Auto-launches tmux session `main` on open
- Audio bell disabled
- Update check disabled

### tmux

- **Config:** `~/.config/tmux/tmux.conf` (symlink from repo)
- **Prefix:** Ctrl+b (default, but all navigation is prefix-free via Alt)
- Vi mode in copy mode, wl-copy for clipboard
- Navigation: Alt+HJKL (panes), Alt+1-9 (windows), Ctrl+Alt+HJKL (resize)
- Splits: Alt+\ (vertical), Alt+- (horizontal)
- Mouse: enabled
- Base index: 1
- TPM plugins: tmux-gruvbox (theme), tmux-resurrect, tmux-continuum (auto-save, auto-restore)

### Neovim

- **Config:** `~/.config/nvim/init.lua` (symlink from repo)
- Plugin manager: lazy.nvim (auto-bootstraps)
- Theme: tokyonight-night
- LSP: mason + mason-lspconfig
- Completion: nvim-cmp (LSP, snippets, buffer, path)
- File explorer: nvim-tree
- Fuzzy finder: telescope
- Statusline: lualine
- Tabs: bufferline
- Git: gitsigns
- which-key for keybind discovery
- Relative line numbers
- Clipboard: unnamedplus (system clipboard)

## Aesthetic

Win98/Chicago95 theme across GTK and Waybar. Not nostalgia — it's lightweight and consistent.

| Element | Value |
|---------|-------|
| GTK Theme | Chicago95 |
| Icons | Chicago95 |
| Cursor | Chicago95_Cursor_White |
| Font | Terminess Nerd Font (GTK) / Unifont (terminal) |
| Colors | Silver (#c0c0c0), Navy (#000080), Grey (#808080) |

Zero animations, zero rounding, zero blur. Shadows disabled.

## Known Issues / Pending

- [ ] Switch GPU from nouveau (dGPU) to i915 (iGPU) — biggest battery win
- [ ] After GPU switch: update hardware cursors and brightness keybind
- [ ] sdb1: reformat to btrfs (need external drive for 253G temp storage)
- [ ] Move qemu images to sdb1 after reformat
- [ ] Set up btrfs send/receive backup from sda2 to sdb1
- [ ] dnscrypt-proxy blocklist needs periodic regeneration
- [ ] 120Hz → 60Hz on battery (evaluate savings)
- [ ] GRUB Shodan theme not deployed yet

## Update Instructions

**For Claude:** Update this file whenever system changes are made during a session. Bump the "Last verified" date on each update. Only document current factual state — no planned or aspirational content except in Known Issues.
