export PATH=~/bin:~/.local/bin:~/.cargo/bin:$PATH
export TERMINAL=kitty
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
function more { less "$@" } # Workaround for zsh using more instead of less
export LS_COLORS='rs=0:di=01;37:ln=00;34:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32';
export EZA_COLORS="xx=fg:$LS_COLORS"
export FZF_DEFAULT_OPTS="$(< $HOME/.config/fzf)"
export RIPGREP_CONFIG_PATH=$HOME/.config/rg
