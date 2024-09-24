#!/bin/env zsh

export PATH=~/bin:~/.local/bin:~/.cargo/bin:$PATH

eval "$(ssh-agent -s)" &> /dev/null

export EDITOR=nvim
export VISUAL=nvim

export TERMINAL=kitty

systemctl --user import-environment PATH HOME

if [ -z "$TMUX" ] && [[ -o login ]] && [ -z "$SSH_CONNECTION" ]; then
    ssh-add
fi

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 && -z $TMUX ]]; then
	startx
fi
