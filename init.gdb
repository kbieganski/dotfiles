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
import tempfile

tempdir = tempfile.mkdtemp()
pipes = []
nvim_socket = os.path.join(tempdir, 'nvim-sock')
os.system(f'tmux split-window -h -l 33% -d "nvim --listen {nvim_socket}"')

def on_stop(event):
    gdb.execute(f'call fflush(0)', to_string=True)
    symtab_line = gdb.decode_line()[1][0]
    line = symtab_line.line
    path = symtab_line.symtab.fullname()
    path = path.replace('#', '\\#')
    os.system(f'nvim --server {nvim_socket} --remote-send "<esc><esc>:e{path}<cr>:lua vim.diagnostic.disable()<cr>{line}gg"')

def on_objfile(event):
    if 'libc.so' not in event.new_objfile.filename: return
    pipe = os.path.join(tempdir, f'pipe-{len(pipes)}')
    os.mkfifo(pipe)
    if len(pipes) > 0: os.system(f'tmux respawn-pane -k -t 2 "less -f {pipe}"')
    else: os.system(f'tmux split-window -h -l 33% -d "less -f {pipe}"')
    pipes.append(pipe)
    output = gdb.execute(f'call open("{pipe}", 0102, 0666)', to_string=True)
    output = output.split('=')[-1].strip()
    gdb.execute(f'call dup2({output}, 1)', to_string=True)
    gdb.execute(f'call dup2({output}, 2)', to_string=True)

def on_exit(event):
    os.system(f'nvim --server {nvim_socket} --remote-send "<esc><esc>:qa!<cr>"')
    for pipe in pipes:
        os.remove(pipe)
    if len(pipes) > 0: os.system('tmux kill-pane -t 2')

gdb.events.stop.connect(on_stop)
gdb.events.new_objfile.connect(on_objfile)
gdb.events.gdb_exiting.connect(on_exit)
end

source ~/dotfiles/ext/gdb-dashboard/.gdbinit

dashboard -layout assembly breakpoints expressions history memory registers stack threads variables
dashboard -style prompt_running '\\[\\e[1;34m\\]>>>\\[\\e[0m\\]'
dashboard -style prompt_not_running '\\[\\e[1;32m\\]>>>\\[\\e[0m\\]'
dashboard -style style_selected_1 '34'
dashboard -style style_selected_2 '32'
dashboard -style style_low '37'
dashboard -style syntax_highlighting 'nord'

