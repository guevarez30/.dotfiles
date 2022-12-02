#!/bin/bash

#*****************************
# How To Set up New Monitors 
#*****************************
# 1. Run 'arandr' in terminal 
# 2. Move Screens around for desired monitor layout
# 3. Save xrandr script
# 4. Put script here
# 5. Comment out all other configurations
#*****************************

#*****************************
# Home Office
#*****************************
xrandr --output eDP-1 --off --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output DP-2 --off --output HDMI-3 --off --output DP-2-1 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-2-2 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-2-3 --off
#*****************************

#*****************************
# No Screens
#*****************************
# xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output DP-2 --off --output HDMI-3 --off
#*****************************

#*****************************
# Samsung Bethany (Right) Moms Office
#*****************************
#xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-1 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1 --off --output HDMI-2 --off --output DP-2 --off --output HDMI-3 --off
#*****************************
