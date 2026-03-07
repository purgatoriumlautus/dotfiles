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
- [ ] Comment out laptop monitor: `monitor = eDP-1, preferred, auto, 1`
- [ ] Uncomment/add PC monitor lines (use names from `hyprctl monitors`)
- [ ] Brightness keys — `nv_backlight` is laptop NVIDIA nouveau. Remove or change to PC backlight device
- [ ] `cursor { no_hardware_cursors = true }` — this was a nouveau workaround. Test without it on PC GPU
- [ ] Bluetooth autostart — remove `blueman-applet` line if no bluetooth

### hyprpaper.conf
- [ ] Update monitor names in wallpaper blocks
- [ ] Update wallpaper paths if different images

### waybar/config.jsonc
- [ ] Remove `"battery"` from `modules-right` (desktop has no battery)
- [ ] Remove bluetooth module if no adapter
- [ ] Adjust network module if no wifi

### ly/config.ini
- [ ] Remove `battery_id = BAT1`

### CLAUDE.md
- [ ] Update GPU line to match PC hardware
- [ ] Remove this setup section once complete

### README.md
- [ ] Update any laptop-specific references

## Step 2: Stow & Test

```bash
cd ~/dotfiles
stow hypr waybar tofi kitty tmux mako nvim gtk xfce4 swappy zsh
hyprctl reload
```

## Step 3: Commit

Commit adjustments to master. The `laptop` branch preserves the old config.

## Hardware Reference (from laptop)

These are the laptop-specific values that need replacing:

| Setting | Laptop Value | PC Value |
|---------|-------------|----------|
| Monitor | eDP-1, 1920x1080@120Hz | TBD (run hyprctl monitors) |
| GPU | GTX 1060 Mobile (nouveau) | TBD (run lspci) |
| Backlight | nv_backlight | TBD or N/A |
| Battery | BAT1 | N/A (desktop) |
| Bluetooth | Yes (bluez + blueman) | TBD |
| WiFi | Yes (NetworkManager) | TBD |
