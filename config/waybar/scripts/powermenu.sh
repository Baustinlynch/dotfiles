#!/bin/bash

# Power menu script using fuzzel

OPTIONS="⏻ Shutdown\n⏾ Reboot\n󰒲 Suspend\n󰤄 Hibernate\n󰍃 Logout\n󰷛 Lock"

CHOICE=$(echo -e "$OPTIONS" | fuzzel --dmenu --prompt="Power Menu: " --width=20)

case "$CHOICE" in
    *"Shutdown")
        systemctl poweroff
        ;;
    *"Reboot")
        systemctl reboot
        ;;
    *"Suspend")
        systemctl suspend
        ;;
    *"Hibernate")
        systemctl hibernate
        ;;
    *"Logout")
        niri msg action quit
        ;;
    *"Lock")
        swaylock
        ;;
esac
