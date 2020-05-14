#!/bin/sh

DOTFILES_DIR=$(dirname $(realpath $0))
WORKING_DIR=$(pwd)

function section() {
    echo -e "\n\\e[30;35;1m====== $1 ======\\e[;;m\n"
}

function log() {
    echo -e "\\e[30;33;1m$(date +"%Y-%m-%d %H:%M:%S")\\e[;;m $@"
}

function install() {
    log "Installing: \\e[30;36;10m$@\\e[;;m"
    sudo pacman --needed --noconfirm -S $@
}

function uninstall() {
    log "Uninstalling: \\e[30;36;10m$@\\e[;;m"
    sudo pacman --noconfirm -R $@
}

function pkgbuild_extract() {
    echo "$(grep "^$1=" <PKGBUILD | cut -d= -f 2 | sed "s/['\"]//g")"
}

function pkgbuild_fullname() {
    local PKG_NAME=$(pkgbuild_extract pkgname)
    local PKG_EPOCH=$(pkgbuild_extract epoch)
    local PKG_VER=$(pkgbuild_extract pkgver)
    local PKG_REL=$(pkgbuild_extract pkgrel)
    echo "$PKG_NAME $([ -n "$PKG_EPOCH" ] && echo "$PKG_EPOCH:")$PKG_VER-$PKG_REL"
}

function install_aur() {
    log "Installing from AUR: \\e[30;36;10m$@\\e[;;m"
    for PACKAGE in $@; do
        local CLONE_DIR=$(mktemp --directory)
        clone_git https://aur.archlinux.org/$PACKAGE.git $CLONE_DIR
        cd $CLONE_DIR
        local PKG_STRING=$(pkgbuild_fullname)
        if [ -z "$(pacman -Q | grep "$PKG_STRING")" ]; then
        log "Installing: \\e[30;36;10m$PKG_STRING\\e[;;m"
        makepkg -si --needed --noconfirm
        else
        log "Skipping \\e[30;36;10m$PKG_STRING\\e[;;m as it is already up to date"
        fi
        cd $WORKING_DIR
        log "Removing \\e[30;34;3m$CLONE_DIR\\e[;;m"
        rm -rf $CLONE_DIR
    done
}

function clone_git() {
    log "Cloning \\e[30;34;3m$1\\e[;;m to \\e[30;34;3m$2\\e[;;m"
    if [ -d "$2" ]; then
        cd $2
        if [ "$(git remote get-url origin 2>/dev/null)" = "$1" ]; then
            git fetch -q origin
            git reset --hard origin/master
            cd $WORKING_DIR
        else
            cd $WORKING_DIR
            rm -rf $2
            git clone --depth 1 $1 $2
        fi
    fi
}

function install_pip() {
    log "Installing Python packages: \\e[30;36;10m$@\\e[;;m"
    pip install --user $@
}

function escape_path() {
    echo $1 | sed "s/\//\\\\\//g"
}

function make_dir() {
    log "Making directory \\e[30;34;3m$1\\e[;;m"
    mkdir -p $1
}

function make_copy() {
    log "Copying \\e[30;34;3m$1\\e[;;m to \\e[30;34;3m$2\\e[;;m"
    rm -f $2
    mkdir -p $(dirname $2)
    cp $1 $2
}

function make_link() {
    log "Making symbolic link \\e[30;34;3m$2\\e[;;m to \\e[30;34;3m$1\\e[;;m"
    rm -rf $2
    mkdir -p $(dirname $2)
    ln -s $1 $2
}

section "BASIC DEV TOOLS"
install base-devel
install git

section "SHELLS"
install openssh
install zsh
chsh -s /bin/zsh
clone_git https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
clone_git https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

section "EDITORS"
install emacs
clone_git https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom -y install
install gvim
install aspell

section "COMPILERS AND LANGUAGES"
install gcc
install clang clang-tools-extra
install cmake
install python python-pip
install rust
install go

section "DEBUGGING TOOLS"
install gdb valgrind
install lsof ltrace strace

section "SYNTAX HIGHLIGHTING / LINTING TOOLS"
install cscope
install ctags pygmentize
install_aur global
install_pip jedi json-rpc flake8 autoflake

section "OTHER UTILITIES"
install expect inotify-tools psmisc
install sysstat procps-ng alsa-utils playerctl
install_pip udiskie
install zip unzip
install rclone

section "GRAPHICAL ENVIRONMENT"
install xorg-server xorg-xinit xclip xbindkeys
install i3-wm i3blocks xss-lock redshift
install termite ranger
install dunst rofi
install compton feh
install_aur sxlock-git
install zenity

section "BROWSERS AND VIEWERS"
install qutebrowser firefox chromium w3m
install zathura zathura-pdf-mupdf

section "FONTS"
install ttf-dejavu
install_aur ttf-iosevka otf-jost

section "ENTERTAINMENT"
install steam
install_aur spotify

section "GARBAGE REMOVAL"
uninstall nano
while :; do
    FOR_REMOVAL=$(pacman -Qdtq)
    [ "$FOR_REMOVAL" = "" ] && break
    uninstall $FOR_REMOVAL
done

section "USER CONFIGURATION LINKS"
make_link $DOTFILES_DIR/zsh/env.sh ~/.zshenv
make_link $DOTFILES_DIR/zsh/rc.sh ~/.zshrc
make_link $DOTFILES_DIR/zsh/theme.sh ~/.oh-my-zsh/themes/kb.zsh-theme
make_link $DOTFILES_DIR/xinitrc.sh ~/.xinitrc
make_link $DOTFILES_DIR/termite.conf ~/.config/termite/config
make_link $DOTFILES_DIR/i3.conf ~/.config/i3/config
make_link $DOTFILES_DIR/i3blocks.conf ~/.config/i3blocks/config
make_link $DOTFILES_DIR/dunst.conf ~/.config/dunst/dunstrc
make_link $DOTFILES_DIR/compton.conf ~/.config/compton.conf
make_link $DOTFILES_DIR/passhole.ini ~/.config/passhole.ini
make_link $DOTFILES_DIR/git.conf ~/.gitconfig
make_link $DOTFILES_DIR/Xresources ~/.Xresources

section "DOOM-EMACS CONFIGURATION"
make_link $DOTFILES_DIR/doom ~/.doom.d
~/.emacs.d/bin/doom sync
~/.emacs.d/bin/doom purge

section "USER EXECUTABLE LINKS"
for BIN_TARGET in $DOTFILES_DIR/bin/*sh; do
    BIN_LINK=~/.local/bin/$(echo $(basename $BIN_TARGET) | sed "s/\.sh$//g")
    make_link $BIN_TARGET $BIN_LINK
done
make_link ~/.emacs.d/bin/doom ~/.local/bin/doom
make_link ~/.local/bin ~/bin

section "USER DESKTOP ENTRIES"
for APP_TARGET in $DOTFILES_DIR/desktop/*; do
    APP_LINK=~/.local/share/applications/$(basename $APP_TARGET)
    make_link $APP_TARGET $APP_LINK
done

section "BACKGROUND SERVICES"
DROPBOX_DIR=~/dropbox
GOOGLE_DRIVE_DIR=~/google-drive
SYSTEMD_UNITS_DIR=~/.config/systemd/user
make_dir $DROPBOX_DIR
make_dir $GOOGLE_DRIVE_DIR
make_dir $SYSTEMD_UNITS_DIR

for SERVICE_FILE in $DOTFILES_DIR/systemd/*; do
    SERVICE_FILE_COPY=$SYSTEMD_UNITS_DIR/$(basename $SERVICE_FILE)
    make_copy $SERVICE_FILE $SERVICE_FILE_COPY
    log "Unmasking \\e[30;34;3m$SERVICE_FILE_COPY\\e[;;m"
    sed -i -e "s/MASK_DOTFILES_DIR/$(escape_path $DOTFILES_DIR)/g" \
           -e "s/MASK_DROPBOX_DIR/$(escape_path $DROPBOX_DIR)/g" \
           -e "s/MASK_GOOGLE_DRIVE_DIR/$(escape_path $GOOGLE_DRIVE_DIR)/" \
        $SERVICE_FILE_COPY
done
systemctl --user daemon-reload
systemctl --user enable emacs; systemctl --user start emacs
systemctl --user enable dropbox; systemctl --user start dropbox
systemctl --user enable google-drive; systemctl --user start google-drive
systemctl --user enable ip-update.timer; systemctl --user start ip-update.timer
