# CLAUDE.md - Dotfiles

System-specific context for this dotfiles repository.

## New Machine Setup

If configs haven't been adjusted for this machine yet, read `PC_SETUP.md` and `MIGRATION_PROMPT.md` (Phase 6) for the full checklist. The `laptop` branch preserves the original laptop config. Detect hardware first, then adjust configs on `master`.

## Philosophy

**Performance-driven minimalism.** Every choice optimizes for:
1. **Responsiveness** - System should feel instant
2. **Minimal footprint** - Fewest packages possible
3. **Unix philosophy** - One tool, one job, done well

The Win98/Chicago95 aesthetic is a side effect, not the goal. Lightweight interfaces happen to look retro.

## Why Wayland

- Simpler architecture than X11
- Better documentation
- More secure (isolation by default)
- Industry direction - everything is moving here

## System

| Component | Choice | Why |
|-----------|--------|-----|
| Distro | Arch Linux | Rolling release, minimal base, AUR |
| Compositor | Hyprland | Wayland, tiling, performant, active development |
| Shell | zsh | Tab completion, vi mode, minimal config (no frameworks) |
| Terminal | Kitty | GPU-accelerated, fast |
| Editor | Neovim | Modal editing, lightweight |
| File Manager | Thunar | GTK, lightweight, does the job |
| GPU | GTX 1060 (nouveau) | Proprietary drivers don't work on laptop; check PC GPU |

## Stow Structure

```
~/dotfiles/
├── hypr/           → ~/.config/hypr/
├── waybar/         → ~/.config/waybar/
├── kitty/          → ~/.config/kitty/
├── tofi/           → ~/.config/tofi/
├── tmux/           → ~/.config/tmux/
├── mako/           → ~/.config/mako/
├── nvim/           → ~/.config/nvim/
├── gtk/            → ~/.config/gtk-{2.0,3.0,4.0}/
├── xfce4/          → ~/.config/xfce4/
├── swappy/         → ~/.config/swappy/
├── ly/             → /etc/ly/ (reference only, requires sudo)
├── grub/           → /boot/grub/themes/ (reference only, manual copy)
└── zsh/            → ~/
```

**Note:** `ly/` and `grub/` contain system-level configs that can't be stowed to home. They're kept here as reference and must be copied manually with sudo.

## What Goes Where

- **Stow-able configs** (user-level, `~/.config/`): Create proper directory structure, stow it
- **System configs** (`/etc/`, `/boot/`): Keep in repo as reference, document manual install in README
- **Secrets/credentials**: Never commit. Use `.gitignore`.

## Aesthetic

Win98/Chicago95 theme across GTK and Waybar. Not nostalgia - it's lightweight and consistent.

| Element | Value |
|---------|-------|
| GTK Theme | Chicago95 |
| Icons | Chicago95 |
| Cursor | Chicago95_Cursor_White |
| Font | Terminess Nerd Font |
| Colors | Silver (#c0c0c0), Navy (#000080), Grey (#808080) |
