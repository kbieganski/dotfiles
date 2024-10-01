function onmod {
    local loop=true

    declare -a files

    while [ -n "$1" ]; do
        case "$1" in
            -h|--help)
              echo "Usage: $0 [options] [file...] -- command..."
              echo "Options:"
              echo "  -h, --help    Display this help message"
              echo "  -1, --oneshot Only run once"
              exit 0
              ;;

            -1|--oneshot)
              loop=false
              ;;

            --)
              shift
              break
              ;;

            *)
              files+=("$1")
              ;;
        esac
        shift
    done

    if [ ${#files[@]} -eq 0 ]; then
        echo "No files to watch"
        exit 1
    fi

    local cond=true
    while $cond; do
        echo "Watching ${files[@]}"
        inotifywait -re attrib,create,delete,modify,move ${files[@]}
        sh -c "$@"
        local cond=$loop
    done
}
