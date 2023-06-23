#!/bin/sh

source /etc/profile.d/debuginfod.sh
#eval "$(ssh-agent -s)"
#ssh-add
#eval `keychain --agents ssh --eval id_rsa`
eval `keychain`
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 && -z $TMUX ]]; then
	startx
fi
