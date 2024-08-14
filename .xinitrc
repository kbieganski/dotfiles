#!/bin/sh

xrdb ~/.Xresources
setxkbmap pl
xbindkeys
autocutsel -fork -selection CLIPBOARD
xrandr --output DVI-D-0 --left-of HDMI-0
xrandr --output DVI-D-0 --rotate left
exec i3
