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
    symtab_line = gdb.decode_line()[1][0]
    line = symtab_line.line
    path = symtab_line.symtab.fullname()
    path = path.replace('#', '\\#')
    os.system(f'nvim --server {nvim_socket} --remote-send "<esc><esc>:e{path}<cr>{line}gg"')

def on_objfile(event):
    if 'libc.so' not in event.new_objfile.filename: return
    if len(pipes) > 0: os.system('tmux kill-pane -t 2')
    pipe = os.path.join(tempdir, f'pipe-{len(pipes)}')
    os.mkfifo(pipe)
    os.system(f'tmux split-window -h -l 33% -d "less -f {pipe}"')
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

