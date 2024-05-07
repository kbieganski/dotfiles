#!/bin/env zsh

export PATH=~/bin:~/.local/bin:~/.cargo/bin:$PATH

eval "$(ssh-agent -s)" &> /dev/null

export EDITOR=nvim
export VISUAL=nvim
export PAGER=nvimpager

export TERMINAL=kitty

export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

source /etc/profile.d/debuginfod.sh

systemctl --user import-environment PATH HOME

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 && -z $TMUX ]]; then
	startx
fi
