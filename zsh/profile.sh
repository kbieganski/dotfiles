#!/bin/sh

#eval "$(ssh-agent -s)"
#ssh-add
#eval `keychain --agents ssh --eval id_rsa`
eval `keychain`
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	startx
fi
