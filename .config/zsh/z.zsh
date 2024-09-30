eval "$(zoxide init zsh)"

function z {
    local dir=$(
        zoxide query --list --score |
            fzf --height 40% --layout reverse --info inline \
                --nth 2.. --tac --no-sort --query "$*" \
                --bind 'enter:become:echo {2..}'
    ) && cd "$dir"
}
