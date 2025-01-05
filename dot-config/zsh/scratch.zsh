function scratch {
    local verilator=false
    if [ -n "$1" ]; then
        if [ "$1" = "verilator" ]; then
            verilator=true
        else
            echo "Invalid argument(s)"
            return
        fi
    fi

    local scratch_dir=$(mktemp -d -t scratch-XXXXXXXXXX)
    pushd $scratch_dir &> /dev/null

    if $verilator; then
        PATH=$HOME/work/verilator/bin:$PATH
        echo "
module test;
    reg clk = 0;
    always #1 clk <= ~clk;
    initial #1000 \$stop;
endmodule
        " > test.sv
        tmux split-window -h -c $(pwd) -d "watchexec 'verilator --binary *.sv --prefix test && obj_dir/test'"
        $EDITOR test.sv
    fi
}
