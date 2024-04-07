{ config, pkgs, ... }:


let username = "k";
    homeDir = /home/${username};
    dotfilesDir = /${homeDir}/dotfiles;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "k";
  home.homeDirectory = "/home/k";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.starship.enable = true;  # prompt

  services.syncthing.enable = true;

  home.packages = with pkgs; [
    zsh
    tmux
    openssh
    mosh  # feature-rich ssh client
    bat  # modern cat with syntax highlighting
    eza  # ls replacement
    delta  # diff viewer
    difftastic  # syntactic diff
    rm-improved  # better rm
    du-dust  # modern du
    duf  # better df
    fd  # better find
    gh  # GitHub CLI
    tokei  # source code counter
    fzf  # general purpose fuzzy finder
    mcfly  # shell history searcher
    choose  # better cut
    jq  # JSON querying tool
    sd  # sed alternative
    sad  # space age sed
    navi  # interactive shell cheatsheet
    cheat  # interactive shell cheatsheet
    tealdeer  # short man pages
    bottom  # top alternative
    hyperfine  # benchmarking tool
    gping  # ping with a graph
    procs  # modern ps
    up  # interactive shell pipes
    curlie  # modern curl
    xh  # modern HTTP client
    zoxide  # modern cd
    firefox  # web browser
    hexyl  # hex viewer
    moreutils  # various utils
    hck  # modern cut
    entr  # run commands on change
    fclones  # find file duplicates

    starship
    man-pages
    man-pages-posix

    # build systems
    gnumake
    cmake

    # prog langs
    clang
    clang-tools
    deno
    ripgrep
    rustup
    sumneko-lua-language-server
    copilot-cli

    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    iosevka
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })

    sway
    swaylock
    swayidle
    i3status
    i3blocks
    wl-clipboard
    mako
    kitty
    wofi
    waybar
  ];


  home.file.".profile".source = /${dotfilesDir}/profile.sh;
  home.file.".zshrc".source = /${dotfilesDir}/zshrc.sh;
  home.file.".gitconfig".source = /${dotfilesDir}/git.conf;
  xdg.configFile."starship.toml" = { source = /${dotfilesDir}/starship.toml; };
  xdg.configFile."kitty/kitty.conf" = { source = /${dotfilesDir}/kitty.conf; };
  xdg.configFile."nvim".source = /${dotfilesDir}/nvim;
  xdg.configFile."tmux/tmux.conf".source = /${dotfilesDir}/tmux.conf;
  xdg.configFile."bat/config".source = /${dotfilesDir}/tmux.conf;

  xdg.configFile."sway/config".source = /${dotfilesDir}/sway.conf;

  home.file.".xinitrc".source = /${dotfilesDir}/xinitrc.sh;
  home.file.".Xresources".source = /${dotfilesDir}/Xresources;
  xdg.configFile."i3/config".source = /${dotfilesDir}/i3.conf;
  xdg.configFile."i3blocks/config".source = /${dotfilesDir}/i3blocks.conf;
  xdg.configFile."dunst/dunstrc".source = /${dotfilesDir}/dunst.conf;
  xdg.configFile."picom.conf".source = /${dotfilesDir}/picom.conf;
  xdg.configFile."rofi/config.rasi" = { source = /${dotfilesDir}/rofi-config.rasi; };
  xdg.configFile."rofi/theme.rasi" = { source = /${dotfilesDir}/rofi-theme.rasi; };

  xdg.configFile."keepmenu/config.ini".source = /${dotfilesDir}/keepmenu.ini;

  fonts.fontconfig.enable = true;
}
