export PATH=~/bin:~/.local/bin:~/.cargo/bin:$PATH

eval "$(ssh-agent -s)" &> /dev/null

export TERMINAL=kitty

export LS_COLORS='rs=0:di=01;37:ln=00;34:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32';

systemctl --user import-environment PATH HOME

if [ -z "$TMUX" ] && [[ -o login ]] && [ -z "$SSH_CONNECTION" ]; then
    ssh-add
fi

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 && -z $TMUX ]]; then
	startx
fi
