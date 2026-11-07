SPACESHIP_HOST_PREFIX='󰖟 '
SPACESHIP_USER_COLOR=blue
SPACESHIP_DIR_PREFIX=' '
SPACESHIP_GIT_PREFIX=
SPACESHIP_GIT_BRANCH_COLOR=yellow
SPACESHIP_PACKAGE_PREFIX=
SPACESHIP_PACKAGE_SYMBOL='📦'
SPACESHIP_VENV_PREFIX='🐍'
SPACESHIP_VENV_COLOR=yellow
SPACESHIP_EXEC_TIME_PREFIX='  '
SPACESHIP_EXEC_TIME_COLOR=white
SPACESHIP_CHAR_SYMBOL='❯ '
SPACESHIP_PROMPT_ORDER=(
  user
  host
  dir
  git
  package
  venv
  exec_time
  line_sep
  battery
  jobs
  exit_code
  sudo
  char
)

SPACESHIP_GIT_ORDER=(git_branch git_info git_commit)
spaceship_git_info() {
  spaceship::is_git || return
  local info=("${(@f)$(git-prompt-info)}") out=
  (( ${#info} == 4 )) || return
  [[ -n ${info[2]} ]] && out+=" [${info[2]}]"
  (( info[3] )) && out+=" %b%F{green}+${info[3]}"
  (( info[4] )) && out+=" %b%F{red}-${info[4]}"
  [[ -n $out ]] && spaceship::section --color red "$out"
}
