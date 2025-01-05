function profile {
    local funcs=()

    while [ $# -gt 0 ]; do
        case "$1" in
            --elf)
                shift;
                local elf="$1"
                ;;
            --fn)
                shift;
                funcs+=("$1")
                ;;
            *)
                break
                ;;
        esac
        shift
    done

    if [ -z "$1" ]; then
        echo "Usage: profile [--fn <function_name>] <command>"
        return 1
    fi
    if [ -z "$elf" ]; then
        local elf=$1
    fi
    local elf_base=$(basename $elf)

    local syms=$(mktemp)
    local demangled=$(mktemp)
    readelf -sW "$elf" | grep -v '\.' | while read _ _ _ _ _ _ _ sym; do
       echo $sym
    done | tee $syms | c++filt | rustfilt > $demangled

    sudo perf probe -d "probe_$elf_base:*"
    for func in "${funcs[@]}"; do
        local lineno=$(grep -n -m 1 $func $demangled | cut -d: -f1)
        local sym=$(sed "${lineno}q;d" $syms)
        sudo perf probe --no-demangle -x "$elf" "$func=$sym"
        sudo perf probe --no-demangle -x "$elf" "${func}=$sym%return"
    done

    events=''
    for func in "${funcs[@]}"; do
        events+="-e probe_$elf_base:${func} -e probe_$elf_base:${func}__return "
    done
    sudo -E perf record $events -- "$@"
    sudo chown -R $USER:$USER perf.data

    local perf_script=$(mktemp --suffix .py)
    chmod +x $perf_script
    echo "times = {}
    starts = {}

    def trace_end():
        min_time = min(times.values())
        for fn, time in times.items():
            print(f'{fn}: {time} ns (+{time/min_time*100-100:.2f}%)')" > $perf_script

    for func in "${funcs[@]}"; do
        echo "
    def probe_${elf_base}__${func}(event_name, context, common_cpu,
        common_secs, common_nsecs, common_pid, common_comm,
        common_callchain, __probe_ip, perf_sample_dict):
        starts['$func'] = common_secs * 1000000000 + common_nsecs

    def probe_${elf_base}__${func}__return(event_name, context, common_cpu,
        common_secs, common_nsecs, common_pid, common_comm,
        common_callchain, __probe_ip, perf_sample_dict):
        if '$func' not in starts:
            return
        time = (common_secs * 1000000000 + common_nsecs) - starts['$func']
        if '$func' in times:
            times['$func'] = min(time, times['$func'])
        else:
            times['$func'] = time
    " >> $perf_script
    done

    perf script -s $perf_script
}
