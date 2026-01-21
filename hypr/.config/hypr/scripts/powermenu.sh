#!/bin/bash
# Power menu using tofi

options="Sleep\nLogout\nReboot\nShutdown"

selected=$(echo -e "$options" | tofi --prompt-text "" --placeholder-text "" --hide-input true --width 200 --height 160 --num-results 4)

case "$selected" in
    Sleep)
        systemctl suspend
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
