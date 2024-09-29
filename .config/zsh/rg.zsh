function rge() {
    local reload='reload:rg --column --color=always --smart-case {q} || :'
    local opener='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
                      nvim {1} +{2}
                  else
                      nvim +cw -q {+f}
                  fi'
    fzf --disabled --ansi --multi \
        --bind "start:$reload" --bind "change:$reload" \
        --bind "enter:become:$opener" \
        --bind "ctrl-o:execute:$opener" \
        --bind 'alt-a:select-all,alt-d:deselect-all' \
        --delimiter : \
        --preview 'bat {1} --color=always --highlight-line {2}' \
        --preview-window '~4,+{2}+4/3,<80(up)' \
        --query "$*"
}
