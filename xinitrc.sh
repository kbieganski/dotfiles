#!/bin/sh

xrdb ~/.Xresources
setxkbmap pl
xbindkeys
autocutsel -fork -selection CLIPBOARD
exec i3
