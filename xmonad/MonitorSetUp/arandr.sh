#!/bin/bash
sleep 1
xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x1080 --rotate normal --output \ 
  DP1 --off --output DP2 --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off &> /dev/null
