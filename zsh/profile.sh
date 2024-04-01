#!/bin/sh

source /etc/profile.d/debuginfod.sh

eval "$(ssh-agent -s)"
ssh-add

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 && -z $TMUX ]]; then
	startx
fi

LOGIN_SHELL=1
