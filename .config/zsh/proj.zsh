function proj {
    local proj_dir=$HOME/proj
    local owner=
    while [ -n "$1" ]; do
        case "$1" in
            --work)
                local proj_dir=$HOME/work
                shift
                ;;
            *)
                if [ -z $owner ]; then
                    local owner=$1
                    shift
                else
                    echo "Usage: proj [--work] [OWNER]"
                    return
                fi
                ;;
        esac
    done
    mkdir -p $proj_dir
    local remote=$(gh repo list $owner --json name | jq -r ".[] | .name" | sort | uniq)
    local local=$(ls $proj_dir)
    local all=$(echo "$remote\n$local" | sort | uniq)
    local proj=$(echo "$all" | fzf)
    if [ -z "$proj" ]; then
        return
    else
        echo "$local" | grep -xc "$proj" &> /dev/null
        local is_local=$?
        echo $is_local
        if [ $is_local -ne 0 ]; then
            if [ -z $owner ]; then
                gh repo clone $proj $proj_dir/$proj
            else
                gh repo clone $owner/$proj $proj_dir/$proj
            fi
        fi
    fi
    git -C $proj_dir/$proj pull --ff-only

    tmux new-session -s $proj -d -c $proj_dir/$proj 'nvim' \; \
        split-window -h -c $proj_dir/$proj -t $proj:1 \; \
        switch-client -t $proj
}
