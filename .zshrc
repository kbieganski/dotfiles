if [ -z "$TMUX" ]; then
    if [ -z "$SSH_CONNECTION" ] || [ -z "$(tmux ls)" ]; then
        exec tmux new\; set-option destroy-unattached
    else
        exec tmux attach
    fi
fi

setopt extendedglob
setopt nocaseglob
setopt rcexpandparam
setopt numericglobsort
setopt nobeep
setopt appendhistory
setopt histignorealldups

TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

function precmd {
    local ssh_connection=$(tmux show-env | grep "^SSH_CONNECTION")
    if [ -n "$ssh_connection" ]; then
        export $ssh_connection
    else
        unset SSH_CONNECTION
    fi
    local ssh_auth_sock=$(tmux show-env | grep "^SSH_AUTH_SOCK")
    if [ -n "$ssh_auth_sock" ]; then
        export $ssh_auth_sock
    fi
    local display=$(tmux show-env | grep "^DISPLAY")
    if [ -n "$display" ]; then
        export $display
    fi
}

export EDITOR=nvim
export VISUAL=nvim

export LS_COLORS='rs=0:di=01;37:ln=00;34:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32';
export EXA_COLORS="xx=fg:$LS_COLORS"

export FZF_DEFAULT_OPTS="$(< $HOME/.config/fzf)"

source <(cat $(dirname ${(%):-%N})/.config/zsh/*.zsh)
eval "$(starship init zsh)"
source <(fzf --zsh)
source $HOME/dotfiles/ext/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

