function note {
    mkdir -p $HOME/notes
    fzf --walker-root=$HOME/notes \
        --delimiter / --with-nth -1 \
        --bind 'enter:become(nvim $HOME/notes/{})' \
        --bind 'alt-enter:become(nvim $HOME/notes/{q})' \
        --preview 'bat {} --color=always'
}
