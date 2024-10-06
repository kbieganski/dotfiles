function venv {
    local venv_dir="$HOME/.cache/venv"
    mkdir -p "$venv_dir"
    venv=$(ls "$venv_dir" | fzf --preview "source $venv_dir/{}/bin/activate; pip list --local" \
        --bind "alt-enter:print-query+abort")
    if [ "$?" -ne 0 ]; then
        return
    fi
    if [ ! -d "$venv_dir/$venv" ]; then
        virtualenv "$venv_dir/$venv"
    fi
    source "$venv_dir/$venv/bin/activate"
}
