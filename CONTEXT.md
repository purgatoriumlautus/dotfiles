# System Context — celestia

System manifest for Claude. Static snapshot, manually maintained.

**Last verified: 2026-04-03**

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
| Hostname | celestia |
| CPU | AMD Ryzen 5 5600X 6-Core |
| RAM | 16GB DDR4 (no swap active) |
| GPU | AMD RX 6700 XT (Navi 22, amdgpu driver) |
| Wifi | None |
| Bluetooth | None |

### Storage

| Device | Type | Size | Mount | Notes |
|--------|------|------|-------|-------|
| /dev/sdb3 | ext4 | 224G | / | Root (22% used, 168G free) |
| /dev/sdb1 | FAT32 | 1G | /boot | EFI boot |
| /dev/sdb2 | swap | — | — | Swap partition exists but 0B active |
| /dev/sda | BitLocker | — | — | Windows drive, planned for future use |

### Monitors

| Connector | Model | Resolution | Refresh | Position | Workspace |
|-----------|-------|------------|---------|----------|-----------|
| DP-3 | ASUS VG259QR | 1920x1080 | 165Hz | Left (0x0) | 1 |
| DP-2 | BenQ ZOWIE XL | 1920x1080 | 144Hz | Right (1920x0) | 2 |

### Audio

| Component | Value |
|-----------|-------|
| Stack | PipeWire 1.6.2 + WirePlumber |
| Primary sink | Starship/Matisse HD Audio Controller Analog Stereo (onboard) |
| Secondary sink | Navi 21/23 HDMI/DP Audio (GPU, available but not primary) |
| rt-audio-setup | Enabled — real-time audio for Renoise |

## Network

| Property | Value |
|----------|-------|
| Interface | enp5s0 (ethernet only) |
| IP | 192.168.0.18/24 (DHCP) |
| Gateway | 192.168.0.1 |
| DNS | 127.0.0.1 (dnscrypt-proxy — encrypted DoH, ad-blocking) |
| docker0 | 172.17.0.1/16 (Docker bridge, no containers running) |

No wifi or bluetooth hardware.

## Services

### Running

| Service | Description |
|---------|-------------|
| dnscrypt-proxy | Encrypted DNS resolver with ad-blocking |
| ly@tty2 | TUI display manager |
| NetworkManager | Network management |
| pipewire + wireplumber | Audio stack (user service) |
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
| docker.socket | Container runtime (socket-activated, starts on demand) |
| containerd | Docker container runtime backend (starts with Docker) |
| libvirtd | QEMU/KVM virtualization (for VMs, socket-activated) |
| rt-audio-setup | Real-time audio config (for Renoise) |
| nftables | Firewall (loaded at boot, runs in kernel) |
| mpd | Music Player Daemon (installed but disabled — unfinished setup) |

## Security Posture

### Firewall (nftables)

- **Input policy:** drop (default deny)
- Allowed: established/related connections, loopback, ICMP
- Rate-limited reject for unsolicited host packets (5/sec)
- **Forward policy:** accept (Docker manages its own forward rules via iptables-nft)
- **Output policy:** accept
- Config: `/etc/nftables.conf`

### sysctl Hardening

Config: `/etc/sysctl.d/99-hardening.conf`

| Setting | Value | Purpose |
|---------|-------|---------|
| kernel.kptr_restrict | 1 | Hide kernel pointers from non-root |
| kernel.yama.ptrace_scope | 1 | Restrict ptrace to parent processes |
| kernel.randomize_va_space | 2 | Full ASLR enabled |
| net.ipv4.ip_forward | 1 | Required for Docker |
| net.ipv4.conf.all.rp_filter | 1 | Reverse path filtering (anti-spoof) |
| net.ipv4.conf.all.accept_redirects | 0 | Reject ICMP redirects |
| net.ipv4.conf.all.send_redirects | 0 | Don't send ICMP redirects |
| net.ipv4.tcp_syncookies | 1 | SYN flood protection |

### Other

- **SSH:** Installed, disabled, not running
- **Listening ports:** 127.0.0.1:44359 (containerd, localhost only), 127.0.0.1:53 (dnscrypt-proxy)
- **faillock:** Active — locks account after failed sudo attempts

## Installed Packages

### Core System

base, base-devel, linux, linux-firmware, amd-ucode, grub, efibootmgr, sudo

### Compositor / DE

hyprland, waybar, hyprpaper, hyprsunset, mako, tofi, xdg-desktop-portal, xdg-desktop-portal-hyprland, xorg-xwayland

### Terminal / Shell / Editor

kitty, zsh, tmux, neovim, nano

### File Management

thunar, tumbler, yazi, 7zip, unzip

### Media / Audio

pipewire, pipewire-alsa, pipewire-jack, pipewire-pulse, wireplumber, alsa-utils, pavucontrol, mpd, mpc, rmpc, nomacs

### Clipboard / Screenshots

wl-clipboard, cliphist, grim, slurp, satty

### Networking

networkmanager, dnscrypt-proxy

### Virtualization

docker, qemu-full, libvirt, virt-manager, virt-viewer, spice, spice-gtk

### Dev Tools

git, npm, cmake, python-pip, devtools, debugedit, cpio, jq, stow

### CLI Utilities

bat, btop, eza, fd, fzf, zoxide, tldr, fastfetch, ncdu, lsof, tree, plocate, pacman-contrib

### Fonts

ttf-terminus-nerd, ttf-nerd-fonts-symbols, ttf-nerd-fonts-symbols-mono, ttf-dejavu, noto-fonts, noto-fonts-cjk, noto-fonts-emoji

### Applications

firefox, obsidian

### Security

python-pyotp, iptables-nft, nftables (via iptables-nft)

### AUR (foreign)

chicago95-gtk-theme-git, chicago95-icon-theme-git, xcursor-chicago95-git, tofi, nomacs, yay

### Runtime (not via pacman)

- **bun:** Installed at ~/.bun, on PATH
- **nvm:** Node version manager at ~/.nvm

## Stow Structure

```
~/dotfiles/
├── grub/           → /boot/grub/themes/ (reference only, manual copy)
├── gtk/            → ~/.config/gtk-{2.0,3.0,4.0}/
├── hypr/           → ~/.config/hypr/
├── kitty/          → ~/.config/kitty/
├── ly/             → /etc/ly/ (reference only, manual copy)
├── mako/           → ~/.config/mako/
├── mpd/            → ~/.config/mpd/
├── nftables/       → /etc/nftables.conf (reference only)
├── nvim/           → ~/.config/nvim/
├── rmpc/           → ~/.config/rmpc/
├── satty/          → ~/.config/satty/ (if config needed)
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

### Workspace → Monitor Mapping

| Workspace | Monitor | Position |
|-----------|---------|----------|
| 1 | DP-3 (ASUS) | Left |
| 2 | DP-2 (BenQ) | Right |

### Autostart

waybar, hyprsunset, hyprpaper, mako, hyprpm reload, cliphist (text + image watchers)

### hyprbars Plugin

Win98-style window title bars. Bar height 20px, silver background, navy text, grey when inactive. Managed via hyprpm.

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
- Prompt: `[I/N] user@セレスチャル ~/path (branch)` then `>` on next line
- Keyboard layouts in prompt hostname: katakana for celestia
- Clipboard integration: Y/D/P in normal mode use wl-copy/wl-paste
- FZF: fd-backed, Ctrl+G for cd widget
- zoxide: `z` aliased to `cd`
- History: 10000 lines, shared between sessions, dedup
- Correction: enabled for commands and arguments
- NVM + bun on PATH
- LIBVIRT_DEFAULT_URI set to qemu:///system

### kitty

- **Config:** `~/.config/kitty/kitty.conf` (symlink from repo)
- Font: Terminess Nerd Font Mono, size 12
- Theme: Gruvbox Dark
- Auto-launches tmux session `main` on open (`tmux new-session -A -s main`)
- Cursor: block with trail effect
- Scrollback: 10000 lines
- Audio bell disabled
- Update check disabled

### tmux

- **Config:** `~/.config/tmux/tmux.conf` (symlink from repo)
- **Prefix:** Ctrl+b (default, but all navigation is prefix-free via Alt)
- All root keybindings unbound, custom set built from scratch
- Vi mode in copy mode, wl-copy for clipboard
- Navigation: Alt+HJKL (panes), Alt+1-9 (windows), Ctrl+Alt+HJKL (resize)
- Splits: Alt+\ (vertical), Alt+- (horizontal)
- Mouse: enabled
- Base index: 1
- TPM plugins: tmux-gruvbox (theme), tmux-resurrect, tmux-continuum (auto-save every 1min, auto-restore)

### Neovim

- **Config:** `~/.config/nvim/init.lua` (symlink from repo)
- Plugin manager: lazy.nvim (auto-bootstraps)
- Theme: tokyonight-night
- LSP: mason + mason-lspconfig (pyright, bashls, yamlls, dockerls, docker-compose)
- Completion: nvim-cmp (LSP, snippets, buffer, path)
- File explorer: nvim-tree (vim-style nav, Enter opens in new tab)
- Fuzzy finder: telescope (find files, grep, buffers, recent, help)
- Statusline: lualine
- Tabs: bufferline (tab mode, ordinal numbers)
- Git: gitsigns (gutter signs, hunk navigation)
- which-key for keybind discovery
- Scrolloff: 30 (cursor stays centered)
- Relative line numbers
- Clipboard: unnamedplus (system clipboard)
- Arrow keys disabled in normal mode
- VSCode mode: separate vscode.lua loaded when running in VSCode (VS Code uninstalled, file kept for reference)

## Aesthetic

Win98/Chicago95 theme across GTK and Waybar. Not nostalgia — it's lightweight and consistent.

| Element | Value |
|---------|-------|
| GTK Theme | Chicago95 |
| Icons | Chicago95 |
| Cursor | Chicago95_Cursor_White |
| Font | Terminess Nerd Font Mono |
| Colors | Silver (#c0c0c0), Navy (#000080), Grey (#808080) |

Zero animations, zero rounding, zero blur. Shadows disabled.

## Known Issues / Pending

- [ ] zoxide init order in .zshrc — bun completions and bun PATH added after zoxide (should be before)
- [ ] GRUB Shodan theme not deployed yet
- [ ] Swap partition (sdb2) exists but not active
- [ ] mpd — installed but disabled, needs proper setup (bind to localhost, configure library)
- [ ] sda BitLocker drive — planned for future use, not yet set up
- [ ] dnscrypt-proxy blocklist needs periodic regeneration (run generate-domains-blocklist from /usr/share/dnscrypt-proxy/utils/generate-domains-blocklist/)

## Update Instructions

**For Claude:** Update this file whenever system changes are made during a session. Bump the "Last verified" date on each update. Only document current factual state — no planned or aspirational content except in Known Issues.
