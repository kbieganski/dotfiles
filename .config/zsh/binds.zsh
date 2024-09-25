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

