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
