function fman {
    local reload='reload:man -k {q} || :'
    fzf --disabled --ansi \
        --bind "start:$reload" --bind "change:$reload" \
        --bind "enter:become:man {2} {1}" \
        --delimiter '( \(|\)\s+- )' \
        --preview 'man {2} {1}' \
        --preview-window '<80(up)' \
        --query "$*"
}
