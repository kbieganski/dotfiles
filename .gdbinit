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

python
import os
gdb.execute(f"source {os.getenv('DOTFILES')}/ext/gdb-dashboard/.gdbinit")
end

dashboard -layout assembly breakpoints expressions history memory registers stack threads variables
dashboard -style prompt_running '\\[\\e[1;31m\\]>>>\\[\\e[0m\\]'
dashboard -style prompt_not_running '\\[\\e[1;34m\\]>>>\\[\\e[0m\\]'
dashboard -style style_selected_1 '34'
dashboard -style style_selected_2 '32'
dashboard -style style_low '37'

