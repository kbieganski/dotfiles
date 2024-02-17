-- Options
vim.o.autochdir = true                    -- change working dir to buffer dir
vim.o.clipboard = 'unnamedplus'           -- use system clipboard
vim.o.conceallevel = 2
vim.o.cursorline = true                   -- highlight line with cursor
vim.o.expandtab = true                    -- insert spaces with tab
vim.o.foldenable = false
vim.o.hlsearch = false                    -- do not highlight all search matches
vim.o.ignorecase = true                   -- when searching
vim.o.laststatus = 3                      --
vim.o.number = true                       --
vim.o.pumheight = 10                      -- limit shown completion items
vim.o.relativenumber = true
vim.o.scrolloff = 10                      -- keep cursor 10 lines from screen edge
vim.o.shiftwidth = 4                      -- width of indent
vim.o.shortmess = vim.o.shortmess .. 'IS' -- don't show welcome message or search count
vim.o.signcolumn = 'yes:2'                --
vim.o.smartcase = true                    -- don't ignore case if search string contains uppercase letters
vim.o.smartindent = true                  -- indent based on syntax
vim.o.spelllang = 'en_us,pl'              -- check English and Polish spelling
vim.o.spell = true
vim.o.tabstop = 4                         -- width of tab
vim.o.termguicolors = true                -- 24-bit color support
vim.o.timeoutlen = 250                    -- mapping timeout
vim.o.undofile = true                     -- persistent undo
vim.o.updatetime = 1000
vim.o.virtualedit = 'all'                 -- allow virtual editing
vim.o.visualbell = true                   -- disable bleeping
vim.o.writebackup = false                 -- disable backup when overwriting

-- Mappings
vim.g.mapleader = ' '

-- remap Ctrl-C to Esc, so that InsertLeave gets triggered
vim.keymap.set('n', '<C-c>', '<esc>', { silent = true })

-- unmap useless stuff
for _, keys in ipairs({ 'za', 'zA', 'zC', 'ze', 'zH', 'zi', 'zL', 'zm', 'zM', 'zo', 'zO', 'zr', 'zR', 'zs', 'zv', 'zx', 'zf' }) do
    vim.keymap.set('n', keys, function() end, { silent = true, desc = '' })
end
for _, keys in ipairs({ '-', '_', '=', '+', 'm' }) do
    vim.keymap.set('n', keys, function() end, { silent = true, desc = '' })
end

-- delete without yanking with x/X
vim.keymap.set('n', 'x', '"_x', { silent = true })
vim.keymap.set('n', 'X', '"_dd', { silent = true })
vim.keymap.set('v', 'x', '"_x', { silent = true })
vim.keymap.set('v', 'X', '"_dd', { silent = true })

-- replace without yanking the replaced text
vim.keymap.set('v', 'p', '"_dP', { silent = true })

-- newline does not switch mode; newline in insert mode
vim.keymap.set('n', 'o', 'o<esc>kj', { silent = true })
vim.keymap.set('n', 'O', 'O<esc>jk', { silent = true })
vim.keymap.set('i', '<M-o>', '<esc>o', { silent = true })
vim.keymap.set('i', '<M-O>', '<esc>O', { silent = true })

-- redo on U
vim.keymap.set('n', 'U', '<C-r><esc>', { silent = true })

-- move up/down on visual lines
vim.keymap.set('n', 'j', "v:count ? 'j' : 'gj'", { silent = true, expr = true })
vim.keymap.set('n', 'k', "v:count ? 'k' : 'gk'", { silent = true, expr = true })

-- move selected lines up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })

-- window management with alt
vim.keymap.set('n', '<M-q>', vim.cmd.close, { silent = true })
vim.keymap.set('n', '<M-c>', vim.cmd.split, { silent = true })
vim.keymap.set('n', '<M-v>', vim.cmd.vsplit, { silent = true })
vim.keymap.set('n', '<M-H>', '<C-w><S-h>', { silent = true })
vim.keymap.set('n', '<M-J>', '<C-w><S-j>', { silent = true })
vim.keymap.set('n', '<M-K>', '<C-w><S-k>', { silent = true })
vim.keymap.set('n', '<M-L>', '<C-w><S-l>', { silent = true })

-- tab management
vim.keymap.set('n', '<C-t>', vim.cmd.tabnew, { silent = true })
vim.keymap.set('n', '<C-w>', vim.cmd.tabclose, { silent = true })
vim.keymap.set('n', '<C-tab>', vim.cmd.tabnext, { silent = true })
vim.keymap.set('n', '<C-S-tab>', vim.cmd.tabprev, { silent = true })

-- make < and > keep selection
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })

vim.keymap.set('n', 'Z', vim.cmd.qall, { silent = true, desc = 'Quit' })
vim.keymap.set('n', '<M-Z>', function() vim.cmd.qall { bang = true } end, { silent = true, desc = 'Force quit' })
vim.keymap.set('n', '<C-s>', vim.cmd.write, { silent = true, desc = 'Write current file' })
vim.keymap.set('n', '<M-s>', vim.cmd.wall, { silent = true, desc = 'Write all open files' })

vim.keymap.set('n', 'zx', vim.cmd.bdelete, { silent = true, desc = 'Close buffer' })
vim.keymap.set('n', 'zX', function() vim.cmd.bdelete { bang = true } end, { silent = true, desc = 'Force close buffer' })

-- Rename current file
vim.keymap.set('n', 'zr', function()
    local filename = vim.api.nvim_buf_get_name(0)
    vim.ui.input({ prompt = 'New filename: ', default = filename, completion = 'file' }, function(new_filename)
        if new_filename == '' then
            return
        end
        if vim.fn.filereadable(filename) == 1 then
            vim.cmd.write(new_filename)
            vim.cmd.bdelete(1)
            vim.cmd.edit(new_filename)
            vim.fn.delete(filename)
        else
            vim.api.nvim_buf_set_name(0, new_filename)
        end
    end)
end, { silent = true, desc = 'Rename current file' })

-- Autocmds
-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained' }, {
    group = vim.api.nvim_create_augroup('checktime', {}),
    callback = function() vim.cmd.checktime() end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    -- slient! needed to avoid error because of bug with virtual edit
    command = "silent! lua vim.highlight.on_yank { higroup = 'Search' }",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd('VimResized', {
    group = vim.api.nvim_create_augroup('resize_splits', {}),
    callback = function() vim.cmd.tabdo 'wincmd =' end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('last_loc', {}),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('close_with_q', {}),
    pattern = {
        'PlenaryTestPopup',
        'help',
        'lspinfo',
        'man',
        'notify',
        'qf',
        'query', -- :InspectTree
        'startuptime',
        'tsplayground',
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('markdown_link_mapping', {}),
    pattern = 'markdown',
    callback = function(e)
        vim.keymap.set('n', '<leader>l',
            function()
                local url = vim.fn.getreg '+'
                if url == '' then return end
                local cmd = 'curl -L ' .. vim.fn.shellescape(url) .. ' 2>/dev/null'
                local handle = io.popen(cmd)
                if not handle then return end
                local html = handle:read '*a'
                handle:close()
                local title = ''
                local pattern = '<title>(.-)</title>'
                local m = string.match(html, pattern)
                if m then title = m end
                if title ~= '' then
                    local pos = vim.api.nvim_win_get_cursor(0)[2]
                    local line = vim.api.nvim_get_current_line()
                    local link = '[' .. title .. '](' .. url .. ')'
                    local new_line = line:sub(0, pos) .. link .. line:sub(pos + 1)
                    vim.api.nvim_set_current_line(new_line)
                else
                    vim.notify('Title not found for link')
                end
            end,
            { buffer = e.buf, silent = true, desc = 'Paste link' })
    end
})

-- Filetypes
vim.filetype.add {
    extension = {
        templ = 'templ'
    },
}

-- Plugins
-- Bootstrap lazy.nvim and setup plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath
    }
end
vim.opt.rtp:prepend(lazypath)
require 'lazy'.setup 'plugins'

-- Handy module reload function
function R(name)
    require 'plenary.reload'.reload_module(name)
    return require(name)
end
