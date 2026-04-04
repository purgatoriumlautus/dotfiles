# Laptop Audit & Restructure — magi

> **For agentic workers:** This plan is interactive — each layer is explored together with the user, decisions are made collaboratively, and changes are implemented before moving to the next layer.

**Goal:** Full system audit of magi, clean/harden to match celestia, optimize for battery, restructure repo files.

**Architecture:** Walk through every layer of the system bottom-up (bare Arch → what's on top). At each layer: explore together, discuss findings, decide what stays/goes/changes, implement. After all layers are clean, restructure repo files to match celestia's format.

**Spec:** `docs/superpowers/specs/2026-04-04-laptop-audit-design.md`
**Reference:** `~/dotfiles_pc/CONTEXT.md` (celestia's target structure)

---

## Layer 0: Safety Checkpoint

- [ ] Commit current dotfiles state before any changes

```bash
cd ~/dotfiles && git add -A && git status
git commit -m "checkpoint: pre-audit state"
```

---

## Layer 1: Hardware & Storage

**What we're looking at:** The physical machine — what's this laptop made of?

- [ ] CPU, RAM, GPU, battery
- [ ] Disk layout, partitions, filesystem, swap
- [ ] Disk usage — what's eating space
- [ ] Display, wifi/bluetooth hardware
- [ ] **Discuss & decide:** Any hardware-specific actions needed?

---

## Layer 2: Drivers

**What we're looking at:** What bridges hardware to software?

- [ ] GPU driver (nouveau vs nvidia vs other)
- [ ] Wifi driver
- [ ] Bluetooth driver
- [ ] Power/thermal management drivers
- [ ] **Discuss & decide:** Right drivers? Missing any? Unnecessary ones loaded?

---

## Layer 3: System Services

**What we're looking at:** Everything systemd runs — the engine room.

- [ ] All enabled services (system + user)
- [ ] All running services
- [ ] Compare against celestia's service list
- [ ] Socket-activated services, timers
- [ ] **Discuss & decide:** What's unnecessary? What's missing? Disable/enable.

---

## Layer 4: Power Management

**What we're looking at:** Battery life — the big laptop concern.

- [ ] Current power tools (TLP? power-profiles-daemon? nothing?)
- [ ] CPU governor
- [ ] Thermal management
- [ ] Lid close / suspend / hibernate behavior
- [ ] Backlight control
- [ ] **Discuss & decide:** Install TLP or alternative. Configure governor. Set lid/suspend behavior.

---

## Layer 5: Network

**What we're looking at:** How this machine talks to the world.

- [ ] Interfaces (wifi, ethernet, bluetooth)
- [ ] NetworkManager config and backend (wpa_supplicant vs iwd)
- [ ] Saved connections
- [ ] DNS resolver chain
- [ ] Wifi power save settings
- [ ] **Discuss & decide:** Switch to iwd? Configure wifi power save? Clean up connections?

---

## Layer 6: Security

**What we're looking at:** Hardening — comparing against celestia's posture.

- [ ] Firewall (nftables) — status and rules vs celestia
- [ ] sysctl hardening — current values vs celestia's 99-hardening.conf
- [ ] DNS encryption (dnscrypt-proxy)
- [ ] SSH and fail2ban status
- [ ] Listening ports
- [ ] Auth hardening (faillock, sudo)
- [ ] **Discuss & decide:** Deploy nftables rules, sysctl hardening, dnscrypt-proxy. Remove dead weight.

---

## Layer 7: Packages

**What we're looking at:** Everything installed on top of base Arch.

- [ ] Full explicit package list, categorized by layer
- [ ] AUR packages
- [ ] Orphans
- [ ] Diff against celestia's package list
- [ ] Non-pacman runtimes (nvm, bun, npm globals, pip)
- [ ] Package cache size
- [ ] **Discuss & decide:** Remove unnecessary packages. Install missing ones. Clean cache.

---

## Layer 8: Desktop Stack

**What we're looking at:** Compositor, bar, launcher, notifications, theming.

- [ ] Hyprland config — diff against celestia (single monitor, GPU, keybinds)
- [ ] Waybar config — modules, monitor setup
- [ ] Tofi, mako, hyprpaper configs
- [ ] GTK theming, icons, cursors, fonts
- [ ] Screenshot tool: swappy (current) vs satty (celestia)
- [ ] **Discuss & decide:** Align configs. Switch screenshot tool? Adapt for single monitor.

---

## Layer 9: User Tools

**What we're looking at:** Terminal, shell, editor, file manager, multiplexer.

- [ ] kitty config — diff against celestia
- [ ] zsh config — prompt (hostname katakana), aliases, functions
- [ ] tmux config — diff against celestia
- [ ] neovim config — diff against celestia
- [ ] **Discuss & decide:** Align configs where appropriate. Keep intentional differences.

---

## Layer 10: Home Directory

**What we're looking at:** Everything in ~/ — clean house.

- [ ] Top-level listing — categorize: needed / junk / misplaced
- [ ] Dot-file sprawl — configs not managed by stow
- [ ] Cache sizes (all of them)
- [ ] Largest directories and files
- [ ] Stow symlink health — broken links
- [ ] Junk files, old downloads, temp files
- [ ] ~/dotfiles_pc — mark for removal after audit
- [ ] **Discuss & decide:** Delete junk. Clean caches. Fix symlinks. Organize.

---

## Layer 11: Stow Structure

**What we're looking at:** The dotfiles repo itself — does it match celestia's structure?

- [ ] Current stow dirs vs celestia's stow dirs
- [ ] Missing dirs: nftables/, sysctl/, mpd/, rmpc/, satty/
- [ ] Extra dirs: swappy/ (if replaced by satty)
- [ ] All symlinks healthy after changes
- [ ] **Discuss & decide:** Add/remove stow dirs to match target.

---

## Layer 12: Restructure Repo Files

**What we're doing:** Making the repo match celestia's file structure.

- [ ] Create CONTEXT.md from all audit findings (matching celestia's format)
- [ ] Replace CLAUDE.md with `@CONTEXT.md` pointer
- [ ] Rewrite README.md matching celestia's format
- [ ] Delete MIGRATION_PROMPT.md
- [ ] Update .gitignore to match celestia
- [ ] Final commit and push on laptop branch
