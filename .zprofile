eval "$(ssh-agent -s)" &> /dev/null

systemctl --user import-environment PATH HOME

if [ -z "$TMUX" ] && [[ -o login ]] && [ -z "$SSH_CONNECTION" ]; then
    ssh-add
fi

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 && -z $TMUX ]]; then
	startx
fi
