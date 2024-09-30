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

_fg() { fg &>/dev/null; zle redisplay }
zle -N _fg
bindkey "^Z" _fg

# Completion
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=* r:|=*'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle :compinstall filename '/home/krzysztof/dotfiles/zshrc.sh'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Environment
export EDITOR=nvim
export VISUAL=nvim

export EZA_COLORS="xx=fg:$LS_COLORS"

export FZF_DEFAULT_OPTS="$(< $HOME/.config/fzf)"

export RIPGREP_CONFIG_PATH=$HOME/.config/rg

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
alias ps=procs
alias pt='procs --tree'
alias pw='procs --watch'
alias pwt='procs --watch --tree'
alias uptime='uptime -p'
alias free='free -h'
alias e=exit
alias q=exit

alias cp='cp -vr'
alias mv='mv -v'
alias rm='rm -vr'
alias rip='rip --graveyard $HOME/trash'
alias r=rip

alias g=git

alias cal='cal -m -3'
alias weather='wget -qO- wttr.in/ | sed -e "s:226m:202m:g"'

alias suspend='systemctl suspend'

alias vim=nvim

alias icat='kitty +kitten icat'

# Source other files
source <(cat $(dirname ${(%):-%N})/.config/zsh/*.zsh)
eval "$(starship init zsh)"
source <(fzf --zsh)
source $HOME/dotfiles/ext/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

