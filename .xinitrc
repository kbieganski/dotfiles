#!/bin/sh

xrdb "$HOME/.Xresources"
setxkbmap pl
xbindkeys

xss-lock --transfer-sleep-lock -- lock &
cat "$HOME/.config/dunst/dunstrc" "$HOME/.config/dunst/theme.conf" | dunst &
autocutsel -fork -selection CLIPBOARD
udiskie &
/usr/lib/geoclue-2.0/demos/agent &
redshift -t 6500:3500 &
picom &

if [ -f "$HOME/.xinitrc.local" ]; then
    . "$HOME/.xinitrc.local"
fi

exec i3
