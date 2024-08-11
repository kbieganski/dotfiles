#!/bin/env zsh

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

function fzf-history {
    BUFFER=$(sed -e ':x /\\\+$/ { N; s/\\\+\n//g ; bx }' < ~/.zsh_history  | fzf)
    zle end-of-line
}
zle -N fzf-history
bindkey '^r' fzf-history
bindkey -M viins '^r' fzf-history
bindkey -M vicmd '^r' fzf-history

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

_fg() { fg }
zle -N _fg
bindkey "^Z" _fg

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

bindkey -v
bindkey '^[[7~' beginning-of-line
bindkey '^[[H' beginning-of-line
bindkey '^[[8~' end-of-line
bindkey '^[[F' end-of-line
bindkey '^[[2~' overwrite-mode
bindkey '^[[3~' delete-char
bindkey '^[[C'  forward-char
bindkey '^[[D'  backward-char
bindkey '^[[5~' history-beginning-search-backward
bindkey '^[[6~' history-beginning-search-forward
bindkey '^[Oc' forward-word
bindkey '^[Od' backward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

alias cd=z
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'

EXA_FLAGS=()
alias l='ls'
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

alias du='dust'
alias df='duf'

alias find='fd'
alias fdi='fd --no-ignore'

alias c='clear'
alias h='history'

alias term='kill'
alias kill='kill -9'
alias ps='procs'
alias pt='procs --tree'
alias pw='procs --watch'
alias pwt='procs --watch --tree'
alias uptime='uptime -p'
alias free='free -h'
alias e='exit'
alias q='exit'

alias cp='cp -vr'
alias mv='mv -v'
alias rm='rm -vr'
alias rip='rip --graveyard $HOME/trash'
alias r='rip'

alias g='git'

alias cal='cal -m -3'
alias weather='wget -qO- wttr.in/ | sed -e "s:226m:202m:g"'

alias nix-shell='nix-shell --run zsh'
alias ns='nix-shell'
alias nsp='nix-shell -p'

alias suspend='systemctl suspend'

alias vim='nvim'

alias icat='kitty +kitten icat'

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

source $HOME/dotfiles/ext/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

