# PC Setup Checklist

This file is read by Claude Code on the PC to know what needs adjusting after cloning from the `laptop` branch.

**Instructions:** On the PC, run `claude` and say: "I migrated from laptop, adjust configs for this machine. Read PC_SETUP.md"

## Step 0: Detect Hardware

Run these to discover the PC's setup:
```bash
hyprctl monitors          # monitor names, resolutions, refresh rates
lspci | grep -i vga       # GPU
ls /sys/class/backlight/  # backlight devices (probably none on desktop)
ls /sys/class/power_supply/  # battery (probably none on desktop)
hostnamectl               # current hostname
ip link                   # network interfaces (ethernet only? wifi?)
bluetoothctl show 2>/dev/null  # bluetooth adapter?
```

## Step 1: Adjust Configs

### hyprland.conf
- [x] Comment out laptop monitor: `monitor = eDP-1, preferred, auto, 1`
- [x] Uncomment/add PC monitor lines (use names from `hyprctl monitors`)
- [x] Brightness keys — `nv_backlight` is laptop NVIDIA nouveau. Remove or change to PC backlight device
- [x] `cursor { no_hardware_cursors = true }` — this was a nouveau workaround. Test without it on PC GPU
- [x] Bluetooth autostart — remove `blueman-applet` line if no bluetooth (was already commented)

### hyprpaper.conf
- [x] Update monitor names in wallpaper blocks
- [x] Update wallpaper paths if different images (using same wallpaper for both)

### waybar/config.jsonc
- [x] Remove `"battery"` from `modules-right` (desktop has no battery)
- [x] Remove bluetooth module if no adapter
- [x] Adjust network module if no wifi (kept ethernet format)

### ly/config.ini
- [x] Remove `battery_id = BAT1` (set to null)

### CLAUDE.md
- [x] Update GPU line to match PC hardware
- [x] Remove setup section once complete

### README.md
- [x] Update security section (was wrong — described old laptop setup)
- [x] Fix installation paths and hyprbars instructions

## Step 2: Stow & Test

```bash
cd ~/new_dotfiles
stow hypr waybar tofi kitty tmux mako nvim gtk xfce4 swappy zsh
hyprctl reload
```

## Step 3: Commit

Commit adjustments to master. The `laptop` branch preserves the old config.

---

## Migration Status: COMPLETE ✓

Completed on magi (2026-03-07):
- Packages installed: stow, mako, cliphist, slurp, swappy, wf-recorder, hyprsunset, brightnessctl
- All 11 stow packages deployed (hypr waybar kitty tofi mako nvim tmux gtk xfce4 swappy zsh)
- hyprbars plugin added via hyprpm
- TPM plugins installed (tmux-gruvbox, tmux-resurrect, tmux-continuum)
- Font fixed: Unifont → Terminess Nerd Font Mono (was broken in kitty config)
- Workspace layout: 1→DP-3 (ASUS 165Hz), 2→DP-2 (BenQ 144Hz)
- ly config copied to /etc/ly/config.ini
- Old configs backed up to ~/.config-backup-20260307

## Hardware Reference

| Setting | Laptop Value | PC Value |
|---------|-------------|----------|
| Monitor | eDP-1, 1920x1080@120Hz | DP-3 (ASUS 165Hz), DP-2 (BenQ 144Hz) |
| GPU | GTX 1060 Mobile (nouveau) | RX 6700 XT (amdgpu) |
| Backlight | nv_backlight | N/A (use monitor controls) |
| Battery | BAT1 | N/A (desktop) |
| Bluetooth | Yes (bluez + blueman) | No |
| WiFi | Yes (NetworkManager) | No (ethernet only: enp5s0) |
| Hostname | - | magi |
