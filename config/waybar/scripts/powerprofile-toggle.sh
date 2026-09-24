#!/bin/bash
current=$(powerprofilesctl get)
if [ "$current" = "power-saver" ]; then
  powerprofilesctl set balanced
else
  powerprofilesctl set power-saver
fi
# tell waybar to redraw this module immediately instead of waiting for the next poll
pkill -RTMIN+8 waybar
