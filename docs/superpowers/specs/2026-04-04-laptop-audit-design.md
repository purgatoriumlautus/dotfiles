# Laptop Audit & Restructure — magi

**Date:** 2026-04-04
**Branch:** laptop
**Repo:** ~/dotfiles (single repo, laptop branch for magi, master for celestia)
**Reference:** ~/dotfiles_pc (local copy of master/celestia state)

## Goal

Full system audit of magi (ASUS FX503VM laptop), clean and harden to match celestia's setup where applicable, optimize for battery life, restructure repo files to match PC's CLAUDE.md/CONTEXT.md/README.md format.

Both machines should operate identically from a dotfiles and Claude perspective, with hardware-appropriate adaptations.

## Mental Model

Imagine a clean Arch Linux install. Everything on top of that base is a deliberate layer:

1. **Kernel / firmware / bootloader** — the floor
2. **Drivers** — GPU, wifi, bluetooth, power
3. **System services** — init, networking, audio, display manager
4. **Security layer** — firewall, sysctl, DNS encryption
5. **Desktop stack** — compositor, bar, launcher, notifications
6. **User tools** — terminal, shell, editor, file manager
7. **Dev tools** — languages, containers, VMs
8. **Configs** — dotfiles, stow structure, theming
9. **Home directory** — files, caches, clutter

Each layer gets questioned: why is this here? Is it needed? Is it the right tool? Can it be lighter?

## Constraints

- Battery optimization is a priority — minimal services, power management
- Same stack as celestia (Hyprland, zsh, kitty, tmux, neovim, Chicago95)
- Same security posture (nftables, sysctl hardening, dnscrypt-proxy)
- Laptop has wifi/bluetooth (celestia does not) — needs configuration
- GPU differs (GTX 1060 nouveau vs AMD RX 6700 XT amdgpu)
- Single display vs dual

## Phase 1 — Deep System Audit

Seven parallel audit agents. Each produces a layered findings report — starting from bare Arch and examining what's built on top.

### Agent 1: Hardware & Storage
- CPU, RAM, GPU (driver in use, driver options), battery health/cycle count
- Display(s): resolution, refresh, connector
- Wifi/bluetooth hardware identification
- Partition table, mount points, filesystem types (check for btrfs subvolumes/snapshots)
- Disk usage breakdown — largest directories and files system-wide
- Swap status: exists? active? sized correctly for hibernate?
- Battery status: `cat /sys/class/power_supply/BAT*/status`, capacity, cycle count

### Agent 2: Packages
- Explicit packages: `pacman -Qe`
- AUR packages: `pacman -Qm`
- Orphans: `pacman -Qdtq`
- Categorize by layer (matching the mental model above):
  - Base system (kernel, firmware, bootloader, filesystem)
  - Drivers (GPU, wifi, bluetooth, power)
  - System services (audio, networking, display manager)
  - Security (firewall, DNS, hardening)
  - Desktop (compositor, bar, launcher, notifications, theming)
  - User tools (terminal, shell, editor, file manager, clipboard, screenshots)
  - Dev tools (languages, build systems, containers, VMs)
  - Applications (browser, media, productivity)
  - Unnecessary / unknown / leftover
- Compare against celestia's package list — flag every difference
- Package cache size (`/var/cache/pacman/pkg`)
- Runtime tools not in pacman: nvm, bun, npm global packages, pip packages

### Agent 3: Services & Power
- All enabled systemd services (system + user level)
- All running services
- Compare against celestia's service list
- Battery/power management: what's installed? TLP? power-profiles-daemon? Nothing?
- Current CPU governor: `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
- Thermal management: thermald or equivalent? (GTX 1060 laptop runs hot)
- Lid close behavior, suspend/hibernate config
- Screen dimming, backlight control
- Identify services that drain battery unnecessarily
- Socket-activated services: which exist, are they appropriate?

### Agent 4: Security
- Firewall: nftables/iptables status and rules (or absence)
- sysctl: current kernel params vs celestia's 99-hardening.conf
- DNS: resolver chain, dnscrypt-proxy installed/enabled/running?
- SSH: installed? enabled? running? If sshd is off, is fail2ban dead weight?
- Listening ports (`ss -tlnp`)
- faillock status, sudo config
- Gap analysis vs celestia's security posture

### Agent 5: Network
- Interfaces: wifi adapter, ethernet, bluetooth
- NetworkManager: status, backend (wpa_supplicant vs iwd — iwd is lighter, better for battery)
- Saved connections/profiles
- DNS resolver configuration
- VPN configuration if any
- WiFi power save settings (affects battery significantly)

### Agent 6: Home Directory Cleanup
- Full `~/` listing — categorize everything: needed / junk / misplaced
- Dot-file sprawl: configs in `~/` or `~/.config/` not managed by stow
- Cache sizes: `~/.cache`, `~/.local/share`, `~/.npm`, `~/.nvm`, `~/.bun`, `~/.mozilla`, etc.
- Largest files/dirs under `~` (ncdu-style breakdown)
- Stow symlink health: broken links, unstowed configs, conflicts
- Temporary/junk/leftover files (*.bak, core dumps, old downloads)
- `~/dotfiles_pc` — note as removable after audit

### Agent 7: Config Diff
- Diff each stow directory against celestia's version
- Flag intentional laptop differences vs accidental drift
- Screenshot tool: swappy (laptop) vs satty (PC) — default recommendation: align with celestia (satty)
- Hyprland config: single monitor, nouveau GPU, battery-related settings
- zsh prompt: hostname katakana (celestia = セレスチャル, magi = ?)
- Stow dirs on PC but not laptop: mpd/, nftables/, sysctl/, rmpc/ — decide disposition for each

## Phase 2 — Review & Clean

**Safety first:** Commit current state before any destructive changes. If btrfs, consider snapshot.

Based on Phase 1 findings:

1. **Packages:** Remove orphans, unnecessary packages. Install missing ones needed to match celestia's security/power posture. Remove fail2ban if sshd is disabled (dead weight)
2. **Services:** Disable unnecessary services. Enable missing security services. Set up power management
3. **Security:** Deploy nftables rules (adapt from celestia for laptop — wifi interface differs from ethernet-only), sysctl hardening, dnscrypt-proxy
4. **Power:** Install and configure TLP or equivalent. Optimize wifi power save. Configure suspend/hibernate. Set appropriate CPU governor
5. **Home directory:** Remove junk, clean caches, organize. Remove ~/dotfiles_pc when no longer needed
6. **Stow dirs:** Add missing dirs (nftables/, sysctl/ if applicable). Switch swappy→satty if decided. Fix broken symlinks. Decide on mpd/rmpc (PC has them disabled/WIP — skip for laptop unless wanted)

## Phase 3 — Restructure Repo Files

1. **CLAUDE.md** — replace contents with:
   ```
   # CLAUDE.md - Dotfiles

   @CONTEXT.md
   ```
   (The `@CONTEXT.md` directive is a Claude Code feature that pulls in the referenced file as context)
2. **CONTEXT.md** — create from audit data, matching celestia's structure section-for-section:
   - System Context header with hostname (magi)
   - Philosophy (shared with celestia)
   - Hardware (laptop-specific: CPU, RAM, GPU, battery, wifi, bluetooth)
   - Storage (partitions, mounts, usage)
   - Monitors (single display)
   - Audio
   - Network (wifi-based, different from celestia's ethernet-only)
   - Services (running + enabled, including power management)
   - Security Posture (firewall, sysctl, DNS, SSH, ports)
   - Installed Packages (full categorized list by layer)
   - Stow Structure
   - Compositor/DE details (Hyprland, single monitor, keybinds)
   - Shell/Terminal/Editor details
   - Aesthetic (shared)
   - Known Issues / Pending
   - Update Instructions
3. **README.md** — rewrite to match celestia's format (components table, stow structure, keybinds, color palette)
4. **MIGRATION_PROMPT.md** — delete (migration is complete)
5. **.gitignore** — align with celestia's version (add tmux plugin exclusion, docs/ exclusion)
6. Commit on laptop branch, push

## Success Criteria

- [ ] Full hardware/software inventory documented in CONTEXT.md
- [ ] No orphan packages remaining
- [ ] Security posture matches celestia (nftables, sysctl, dnscrypt-proxy) adapted for laptop
- [ ] Power management active and configured (TLP or equivalent, CPU governor, wifi power save)
- [ ] Home directory clean — no junk, no unmanaged configs that should be stowed
- [ ] All stow symlinks healthy
- [ ] CLAUDE.md, CONTEXT.md, README.md match celestia's structure
- [ ] MIGRATION_PROMPT.md removed
- [ ] Clean commit on laptop branch
- [ ] No unnecessary services running / enabled
