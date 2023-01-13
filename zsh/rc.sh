export ZSH=~/.oh-my-zsh
theme.sh/bin/theme.sh github-dark
ZSH_THEME='agnoster'
COMPLETION_WAITING_DOTS='true'
DISABLE_UNTRACKED_FILES_DIRTY='true'
HIST_STAMPS='yyyy-mm-dd'
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'
plugins=(colorize emacs extract git gitignore jsontools pip zsh-navigation-tools zsh-syntax-highlighting)

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

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'

alias l='/bin/ls -F --color=auto'
alias ls='/bin/ls -F --color=auto'
alias ll='/bin/ls -lFh --color=auto'
alias la='/bin/ls -lAFh --color=auto'
alias lr='/bin/ls -tRFh --color=auto'
alias lfil='/bin/ls -lFh --color=auto | grep "^-" --color=never'
alias ldir='/bin/ls -lFh --color=auto | grep "^d" --color=never'

alias df='/bin/df -h'
alias du='/bin/du -h'

alias ffil='find . -type f -name'
alias fdir='find . -type d -name'

alias c='clear'
alias h='history'

alias term='kill'
alias kill='kill -9'
alias pl='ps axo pid,user,args,pcpu,pmem'
alias uptime='uptime -p'
alias free='free -h'
alias e='exit'
alias q='exit'

alias cp='/bin/cp -ivr'
alias mv='/bin/mv -iv'
alias rm='/bin/rm -ivrf'

alias ln='/bin/ln -s'
alias hln='/bin/ln'

alias cal='cal -m -3'
alias weather='wget -qO- wttr.in/ | sed -e "s:226m:202m:g"'

alias pacman='pacman --color=auto'
alias pm='pacman --color=auto'
alias makepkg='makepkg -is'
alias mp='makepkg -is'

alias shutdown='/bin/shutdown now'
alias suspend='systemctl suspend'

alias vim='nvim'

export VISUAL=nvim
export EDITOR=nvim

eval "$(starship init zsh)"
