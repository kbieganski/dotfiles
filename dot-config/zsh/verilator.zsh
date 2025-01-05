function verilator-test {
    if local git_root=$(git rev-parse --show-toplevel 2>/dev/null) && [[ $(git remote get-url origin) =~ "verilator" ]]; then
        local root=$git_root
    elif [ -n "$VERILATOR_ROOT" ]; then
        local root=$VERILATOR_ROOT
    else
        local root=$HOME/work/verilator
    fi

    local bat_opts="--color=always --style 'header,grid'"

    pushd "$root/test_regress" &>/dev/null || return 1

    local tests=$(
        fd ".*\.py" t | sed "s/.*t\/\(.*\)\.py/\1/g" |
            \fzf --preview="(bat $bat_opts t/{}.v || clear) && bat $bat_opts t/{}.py" \
                 --multi --prompt "Run Verilator test 🞂 " \
                 --history "$HOME/.verilator-tests" \
                 --bind "load:prev-history"
    )

    for test in $tests; do
        "t/$test.py"
    done

    popd &> /dev/null
}
