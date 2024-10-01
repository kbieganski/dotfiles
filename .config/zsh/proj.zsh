function proj {
    mkdir -p ~/proj
    local remote=$(gh repo list --json name | jq -r ".[] | .name" | sort | uniq)
    local local=$(ls ~/proj)
    local all=$(echo "$remote\n$local" | sort | uniq)
    local proj=$(echo "$all" | fzf)
    if [ "$proj" = "dotfiles" ]; then
        local path=~/$proj
    else
        local is_local=$(echo "$local" | grep -xc "$proj")
        if [ $is_local -eq 0 ]; then
            gh repo clone $proj ~/proj/$proj
        fi
        local path=~/proj/$proj
    fi
    git -C $path pull --ff-only

    tmux new-session -s $proj -d -c $path 'nvim' \; \
        split-window -h -c $path -t $proj:1 \; \
        switch-client -t $proj
}
