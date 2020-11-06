#!/bin/sh

eval "$(ssh-agent -s)"
ssh-add
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	startx
fi
