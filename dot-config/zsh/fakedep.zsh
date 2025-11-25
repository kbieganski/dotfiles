function fakedep {
    local temp=$(mktemp -d)
    local name=$1
    if [[ $# -lt 3 ]] || [ $2 != "--" ]; then
        echo "Usage: fakedep <name> -- dep [deps...]"
        return 1
    fi
    shift 2
    echo "
pkgname=$name
pkgver=1.0
pkgrel=1
arch=('x86_64')
depends=('$(echo $@ | sed "s/\s\+/' '/g")')
" > $temp/PKGBUILD
    pushd $temp &> /dev/null
    makepkg -si --noconfirm
    popd &> /dev/null
}
