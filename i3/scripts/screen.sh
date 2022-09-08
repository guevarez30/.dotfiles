#!/bin/bash

monitors=$(xrandr -q)
echo $monitors

if echo "$monitors" | grep 'HDMI-1 disconnected' && echo "$monitors" | grep 'HDMI-2 disconnected' && echo "$monitors" | grep 'DP-2-1 disconnected' && echo "$monitors" | grep 'DP-2-2 disconnected'; then
  # No Monitors attached
  xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output DP-2 --off --output HDMI-3 --off
else
  # Desktop set up
xrandr --output eDP-1 --off --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output DP-2 --off --output HDMI-3 --off --output DP-2-1 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-2-2 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-2-3 --off
fi
