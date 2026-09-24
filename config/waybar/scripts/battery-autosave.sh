#!/bin/bash
capacity=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

if [ "$status" = "Discharging" ] && [ "$capacity" -lt 20 ]; then
    powerprofilesctl set power-saver
    pkill -RTMIN+8 waybar
fi
