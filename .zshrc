if [ -z "$TMUX" ]; then
    if [ -z "$SSH_CONNECTION" ] || [ -z "$(tmux ls)" ]; then
        exec tmux new\; set-option destroy-unattached
    else
        exec tmux attach
    fi
fi

setopt autocd
setopt appendhistory
setopt extendedglob
setopt histignorealldups
setopt magicequalsubst
setopt nocaseglob
setopt numericglobsort
setopt nobeep

TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Reload environment variables from tmux
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

# Bindings
bindkey -M viins "^[[1~" beginning-of-line
bindkey -M viins  "^[[4~" end-of-line

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
for key in "^[[A" ${terminfo[kcuu1]}; do
    bindkey $key up-line-or-beginning-search
done
for key in "^[[A" ${terminfo[kcuu1]} k; do
    bindkey -M vicmd $key up-line-or-beginning-search
done

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
for key in "^[[B" ${terminfo[kcud1]}; do
    bindkey $key down-line-or-beginning-search
done
for key in "^[[B" ${terminfo[kcud1]} j; do
    bindkey -M vicmd $key down-line-or-beginning-search
done

WORDCHARS=_
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

_fg() { fg &>/dev/null; zle redisplay }
zle -N _fg
bindkey "^Z" _fg


# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'

alias l=ls
alias ls='exa --classify --group-directories-first --git --icons --time-style long-iso'
alias la='ls --all'
alias ll='ls --long'
alias lla='ls --long --all'
alias lr='ls --recurse'
alias lra='ls --recurse --all'
alias lt='ls --tree'
alias lta='ls --tree --all'
alias llr='ls --long --recurse'
alias llra='ls --long --recurse --all'
alias llt='ls --long --tree'
alias llta='ls --long --tree --all'

alias du=dust
alias df=duf

alias fdi='fd --no-ignore'

alias grep=rg
alias rgi='rg --no-ignore'

alias c=clear

alias term=kill
alias kill='kill -9'
alias uptime='uptime -p'
alias free='free -h'
alias e=exit
alias q=exit

alias cp='cp -vr'
alias mv='mv -v'
alias rm='rm -vr'
alias r=rip

alias fzf='fzf --bind "enter:become:nvim {}"'
alias rgl='rgl --bind "enter:become:nvim +{2} {1}"'

alias g=git

alias cal='cal -m -3'
alias weather='wget -qO- wttr.in/ | sed -e "s:226m:202m:g"'

alias suspend='systemctl suspend'

alias sudo='sudo --preserve-env'

alias vim=nvim

alias icat='kitty +kitten icat'

# Source other files
source <(cat $(dirname ${(%):-%N})/.config/zsh/*.zsh)
eval "$(starship init zsh)"
source <(fzf --zsh)
source $HOME/dotfiles/ext/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U compinit
compinit
source $HOME/dotfiles/ext/fzf-tab/fzf-tab.plugin.zsh
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags "${=FZF_DEFAULT_OPTS}"
