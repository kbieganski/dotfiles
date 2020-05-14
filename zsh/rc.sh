export ZSH=~/.oh-my-zsh

ZSH_THEME='kb'
COMPLETION_WAITING_DOTS='true'
DISABLE_UNTRACKED_FILES_DIRTY='true'
HIST_STAMPS='yyyy-mm-dd'
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'
plugins=(colorize emacs extract git gitignore jsontools pip zsh-navigation-tools zsh_reload zsh-syntax-highlighting)

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

alias df='/bin/df -h | grep sd --color=never'

alias ffil='find . -type f -name'
alias fdir='find . -type d -name'

alias sgrep='/bin/grep -R -n -H -C 5 --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'

alias c='clear'
alias h='history'
alias ch='echo > ~/.bash_history'

alias term='kill'
alias kill='kill -9'
alias pl='ps axo pid,user,args,pcpu,pmem'
alias uptime='uptime -p'
alias free='free -h'
alias e='exit'
alias q='exit'

alias cp='cp -ivr'
alias mv='mv -iv'
alias rm='rm -ivrf'

alias ln='/bin/ln -s'
alias hln='/bin/ln'

alias weather='curl -s wttr.in/Wroclaw'
alias pysh='sh -c "python -ic\"import sh\""'

alias pacman='pacman --color=auto'
alias pm='pacman --color=auto'
alias makepkg='makepkg -is'
alias mp='makepkg -is'

alias shutdown='/usr/bin/shutdown now'
alias shutdownin='/usr/bin/shutdown'
alias suspend='systemctl suspend'
