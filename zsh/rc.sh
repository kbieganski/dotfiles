export ZSH=~/.oh-my-zsh
COMPLETION_WAITING_DOTS='true'
DISABLE_UNTRACKED_FILES_DIRTY='true'
HIST_STAMPS='yyyy-mm-dd'
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'
plugins=(extract git git-commit starship zoxide zsh-navigation-tools zsh-syntax-highlighting)

setopt extendedglob      # Regular expressions with *
setopt nocaseglob        # Case insensitive globbing
setopt rcexpandparam     # Array expension with parameters
setopt numericglobsort   # Sort filenames numerically when it makes sense
setopt nobeep            # No beep
setopt appendhistory     # Append history instead of overwriting
setopt histignorealldups # Remove duplicate commands

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Colored completion (different colors for dirs/files/etc)
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

bindkey -e
bindkey '^[[7~' beginning-of-line                 # Home key
bindkey '^[[H' beginning-of-line                  # Home key
bindkey '^[[8~' end-of-line                       # End key
bindkey '^[[F' end-of-line                        # End key
bindkey '^[[2~' overwrite-mode                    # Insert key
bindkey '^[[3~' delete-char                       # Delete key
bindkey '^[[C'  forward-char                      # Right key
bindkey '^[[D'  backward-char                     # Left key
bindkey '^[[5~' history-beginning-search-backward # Page up key
bindkey '^[[6~' history-beginning-search-forward  # Page down key
# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word
bindkey '^[Od' backward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

source $ZSH/oh-my-zsh.sh

export EDITOR=nvim

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
alias fdi='fd -I'

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

alias cp='/bin/cp -ivr'
alias mv='/bin/mv -iv'
alias rm='/bin/rm -ivr'
alias rip='rip --graveyard $HOME/trash'
alias r='rip'

alias ln='/bin/ln -s'
alias hln='/bin/ln'

alias cal='cal -m -3'
alias weather='wget -qO- wttr.in/ | sed -e "s:226m:202m:g"'

alias pacman='pacman --color=auto'
alias pm='pacman --color=auto'
alias makepkg='makepkg -is'
alias mp='makepkg -is'

alias suspend='systemctl suspend'

alias vim='nvim'

export VISUAL=nvim
export EDITOR=nvim

export TERMINAL=kitty

alias lf='\cd "$(\lf -print-last-dir "$@")"'

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

source $HOME/.config/broot/launcher/bash/br

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [[ -z $LOGIN_SHELL ]]; then
   if tmux ls; then
       exec tmux attach
   else
       exec tmux new
   fi
fi
