function note {
    mkdir -p $HOME/notes
    fzf --walker-root=$HOME/notes \
        --delimiter / --with-nth -1 \
        --bind 'enter:become(nvim {})' \
        --bind "alt-enter:become(nvim $HOME/notes/{q})" \
        --preview 'bat {} --color=always'
}

function notes {
    mkdir -p $HOME/notes
    pushd $HOME/notes &> /dev/null
    nvim $(rgl | cut -d: -f1)
    popd $HOME/notes &> /dev/null
}
