eval "$(zoxide init zsh)"

function z {
    local dir=$(
        zoxide query --list |
            fzf --height 40% --layout reverse --info inline \
                --no-sort --query "$*" \
                --bind 'enter:accept'
    ) && cd "$dir"
}
