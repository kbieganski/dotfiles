add-auto-load-safe-path /
set history save
set verbose off
set print pretty on
set print array off
set print array-indexes on
set python print-stack full
set disassembly-flavor intel
set pagination off
set debuginfod enabled on

source ~/dotfiles/ext/gdb-dashboard/.gdbinit

dashboard -layout assembly breakpoints expressions history memory registers stack threads variables
dashboard -style prompt_running '\\[\\e[1;34m\\]>>>\\[\\e[0m\\]'
dashboard -style prompt_not_running '\\[\\e[1;32m\\]>>>\\[\\e[0m\\]'
dashboard -style style_selected_1 '34'
dashboard -style style_selected_2 '32'
dashboard -style style_low '37'
dashboard -style syntax_highlighting 'nord'

