-- Options
vim.o.autochdir = true                    -- change working dir to buffer dir
vim.o.clipboard = 'unnamedplus'           -- use system clipboard
vim.o.cursorline = true                   -- highlight line with cursor
vim.o.expandtab = true                    -- insert spaces with tab
vim.o.foldenable = false                  -- no code folding
vim.o.hlsearch = false                    -- do not highlight all search matches
vim.o.ignorecase = true                   -- when searching
vim.o.laststatus = 3                      -- single, global statusline
vim.o.number = true                       -- show line numbers
vim.o.pumheight = 10                      -- limit shown completion items
vim.o.relativenumber = true               -- show relative line numbers
vim.o.scrolloff = 10                      -- keep cursor 10 lines from screen edge
vim.o.shiftwidth = 4                      -- width of indent
vim.o.showmode = false                    -- don't show mode in command line
vim.o.shortmess = vim.o.shortmess .. 'IS' -- don't show welcome message or search count
vim.o.smartcase = true                    -- don't ignore case if search string contains uppercase letters
vim.o.smartindent = true                  -- indent based on syntax
vim.o.spelllang = 'en_us,pl'              -- check English and Polish spelling
vim.o.spell = true                        -- enable spell checking
vim.o.tabstop = 4                         -- width of tab
vim.o.termguicolors = true                -- 24-bit color support
vim.o.undofile = true                     -- persistent undo
vim.o.updatetime = 1000                   -- time for various update events
vim.o.virtualedit = 'all'                 -- allow virtual editing
vim.o.visualbell = true                   -- disable bleeping
vim.o.writebackup = false                 -- disable backup when overwriting
vim.g.python_indent = 'shiftwidth()'      -- set Python auto-indent to shiftwidth
vim.g.loaded_netrwPlugin = 1              -- disable netrw

local diagnostic_signs = {
    [vim.diagnostic.severity.ERROR] = ' ',
    [vim.diagnostic.severity.WARN] = ' ',
    [vim.diagnostic.severity.INFO] = ' ',
    [vim.diagnostic.severity.HINT] = ' ',
}
vim.diagnostic.config {
    virtual_text = false,
    update_in_insert = true,
    signs = { text = diagnostic_signs }
}

-- Mappings
vim.g.mapleader = ' '

-- Remap Ctrl-C to Esc, so that InsertLeave gets triggered
vim.keymap.set('n', '<C-c>', '<esc>', { silent = true })

-- Easier save
vim.keymap.set('n', '<leader>w', vim.cmd.w, { silent = true, desc = 'Write file' })
vim.keymap.set('n', '<leader>W', vim.cmd.wa, { silent = true, desc = 'Write all files' })

-- Unmap useless stuff
for _, keys in ipairs({ 'za', 'zA', 'zc', 'zC', 'zd', 'zD', 'ze', 'zE', 'zH', 'zi', 'zL', 'zm', 'zM', 'zo', 'zO', 'zr', 'zR', 'zs', 'zv', 'zx', 'zf' }) do
    vim.keymap.set({ 'n', 'v' }, keys, function() end, { silent = true, desc = '' })
end

-- Delete without yanking with x/X
vim.keymap.set('n', 'x', '"_x', { silent = true })
vim.keymap.set('n', 'X', '"_dd', { silent = true })
vim.keymap.set('v', 'x', '"_x', { silent = true })
vim.keymap.set('v', 'X', '"_dd', { silent = true })

-- Replace without yanking the replaced text
vim.keymap.set('v', 'p', '"_dP', { silent = true })

-- Newline does not switch mode; newline in insert mode
vim.keymap.set('n', 'o', 'o<esc>kj', { silent = true })
vim.keymap.set('n', 'O', 'O<esc>jk', { silent = true })
vim.keymap.set('i', '<M-o>', '<esc>o', { silent = true })
vim.keymap.set('i', '<M-O>', '<esc>O', { silent = true })

-- Move up/down on visual lines
vim.keymap.set('n', 'j', "v:count ? 'j' : 'gj'", { silent = true, expr = true })
vim.keymap.set('n', 'k', "v:count ? 'k' : 'gk'", { silent = true, expr = true })

-- Move selected lines up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })

-- Window management with alt
vim.keymap.set('n', '<M-q>', vim.cmd.close, { silent = true })
vim.keymap.set('n', '<M-b>', vim.cmd.split, { silent = true })
vim.keymap.set('n', '<M-v>', vim.cmd.vsplit, { silent = true })
vim.keymap.set('n', '<M-H>', '<C-w><S-h>', { silent = true })
vim.keymap.set('n', '<M-J>', '<C-w><S-j>', { silent = true })
vim.keymap.set('n', '<M-K>', '<C-w><S-k>', { silent = true })
vim.keymap.set('n', '<M-L>', '<C-w><S-l>', { silent = true })

-- Tab management
vim.keymap.set('n', '<C-t>', vim.cmd.tabnew, { silent = true })
vim.keymap.set('n', '<C-w>', vim.cmd.tabclose, { silent = true })
vim.keymap.set('n', '<C-tab>', vim.cmd.tabnext, { silent = true })
vim.keymap.set('n', '<C-S-tab>', vim.cmd.tabprev, { silent = true })

-- Make < and > keep selection
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })

-- Rename current file
vim.keymap.set('n', '<leader>R', function()
    local filename = vim.api.nvim_buf_get_name(0)
    vim.ui.input({ prompt = 'New filename: ', default = filename, completion = 'file' }, function(new_filename)
        if not new_filename or new_filename == '' then
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

-- Interactive shell commands
local function get_visual_selection()
    if vim.api.nvim_get_mode().mode ~= 'v' then
        return ''
    else
        local _, ls, cs = unpack(vim.fn.getpos('v'))
        local _, le, ce = unpack(vim.fn.getpos('.'))
        ls = ls - 1; le = le - 1; cs = cs - 1
        local lines = vim.api.nvim_buf_get_text(0, math.min(ls, le),
            math.min(cs, ce), math.max(ls, le), math.max(cs, ce), {})
        return table.concat(lines, ' ')
    end
end

local function run_get_stdout(cmd, fn)
    local prev_buf = vim.api.nvim_get_current_buf()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_set_option_value('number', false, { scope = 'local', win = 0 })
    vim.api.nvim_set_option_value('relativenumber', false, { scope = 'local', win = 0 })
    vim.api.nvim_set_option_value('spell', false, { scope = 'local', win = 0 })
    local tempfile = vim.fn.tempname()
    vim.fn.termopen(cmd .. ' > ' .. tempfile, {
        on_exit = function()
            vim.api.nvim_set_current_buf(prev_buf)
            vim.api.nvim_buf_delete(buf, { force = true })
            if (vim.fn.filereadable(tempfile) ~= 0) then
                local selected = vim.fn.readfile(tempfile)[1]
                fn(selected)
            end
        end
    })
    vim.cmd.startinsert()
end

local function edit_grep(selected)
    local filename, line, col = selected:match('^(.*):(%d+):(%d+):')
    line = tonumber(line)
    col = tonumber(col) - 1
    vim.cmd.edit(filename)
    vim.api.nvim_win_set_cursor(0, { line, col })
end

local function fzf_cmd()
    return 'fzf --query "' ..
        get_visual_selection() ..
        '" --preview "bat {} --color=always" --preview-window="<80(up)" --history=' ..
        vim.fn.stdpath 'data' .. '/fzf-history'
end

local function rgl_cmd()
    return 'rgl --query "' .. get_visual_selection() .. '" --history=' .. vim.fn.stdpath 'data' .. '/rgl-history'
end

vim.keymap.set('n', '<leader>f',
    function() run_get_stdout('lf -print-selection', vim.cmd.edit) end,
    { silent = true, desc = 'File browser' })

vim.keymap.set({ 'n', 'v' }, '|',
    function() run_get_stdout(fzf_cmd(), vim.cmd.edit) end,
    { silent = true, desc = 'Find file' })
vim.keymap.set({ 'n', 'v' }, '<M-|>',
    function() run_get_stdout(fzf_cmd() .. ' --bind load:prev-history', vim.cmd.edit) end,
    { silent = true, desc = 'Find file' })

vim.keymap.set({ 'n', 'v' }, '<leader>|',
    function() run_get_stdout('git ' .. fzf_cmd(), vim.cmd.edit) end,
    { silent = true, desc = 'Find file in repository' })
vim.keymap.set({ 'n', 'v' }, '<leader><M-|>',
    function() run_get_stdout('git ' .. fzf_cmd() .. ' --bind load:prev-history', vim.cmd.edit) end,
    { silent = true, desc = 'Find file in repository' })

vim.keymap.set({ 'n', 'v' }, '\\',
    function() run_get_stdout(rgl_cmd(), edit_grep) end,
    { silent = true, desc = 'Grep files' })
vim.keymap.set({ 'n', 'v' }, '<M-\\>',
    function() run_get_stdout(rgl_cmd() .. ' --bind load:prev-history', edit_grep) end,
    { silent = true, desc = 'Grep files' })

vim.keymap.set({ 'n', 'v' }, '<leader>\\',
    function() run_get_stdout('git ' .. rgl_cmd(), edit_grep) end,
    { silent = true, desc = 'Grep repository' })
vim.keymap.set({ 'n', 'v' }, '<leader><M-\\>',
    function() run_get_stdout('git ' .. rgl_cmd() .. ' --bind load:prev-history', edit_grep) end,
    { silent = true, desc = 'Grep repository' })

vim.keymap.set('n', '<leader>n',
    function() run_get_stdout('note --print', vim.cmd.edit) end,
    { silent = true, desc = 'Note find' })
vim.keymap.set('n', '<leader>N',
    function() run_get_stdout('notes --print', edit_grep) end,
    { silent = true, desc = 'Note grep' })

-- Autocmds
-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained' }, {
    group = vim.api.nvim_create_augroup('checktime', {}),
    callback = function() vim.cmd.checktime() end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    callback = function() vim.highlight.on_yank { higroup = 'Search' } end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd('VimResized', {
    group = vim.api.nvim_create_augroup('resize_splits', {}),
    callback = function() vim.cmd.tabdo 'wincmd =' end,
})

-- Go to last location when opening a buffer
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

-- Replace netrw with lf
vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('open_lf_on_dir', {}),
    pattern = '*',
    callback = function(ev)
        if vim.bo.buftype == 'term' then
            return
        end
        if vim.fn.isdirectory(vim.fn.expand '%') == 1 then
            vim.api.nvim_buf_delete(ev.buf, { force = true })
            run_get_stdout('lf -print-selection', vim.cmd.edit)
        end
    end,
})

-- Markdown-specific settings:
-- - conceal links
-- - paste link with title using <leader>l
-- - open preview with <leader><CR>
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('markdown_filetype', {}),
    pattern = 'markdown',
    callback = function(e)
        vim.opt_local.conceallevel = 2 -- conceal links
        vim.keymap.set('n', '<leader>l',
            function()
                local url = vim.fn.getreg '+'
                if url == '' then return end
                local cmd = 'curl -L ' .. vim.fn.shellescape(url) .. ' 2>/dev/null'
                local handle = io.popen(cmd)
                if not handle then return end
                local html = handle:read '*a'
                handle:close()
                local pattern = '<title>(.-)</title>'
                local title = string.match(html, pattern)
                if title then
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
        vim.keymap.set('n', '<leader><CR>',
            function()
                local peek = require 'peek'
                if peek.is_open() then
                    peek.close()
                else
                    vim.fn.system('i3-msg split horizontal')
                    peek.open()
                end
            end,
            { buffer = e.buff, silent = true, desc = 'Preview' }
        )
    end
})

-- Statusline
function Statusline()
    -- Mode
    local modes = {
        NORMAL = { 'n', 'niI', 'niR', 'niV', 'nt', 'ntT' },
        OPERATOR = { 'no', 'nov', 'noV', 'no' },
        VISUAL = { 'v', 'vs', 'V', 'Vs', '', 's' },
        SELECT = { 's', 'S', '' },
        INSERT = { 'i', 'ic', 'ix' },
        REPLACE = { 'R', 'Rc', 'Rx', },
        ['VI RPL'] = { 'Rv', 'Rvc', 'Rvx' },
        COMMAND = { 'c', 'cr' },
        EX = { 'cv', 'cvr' },
        PROMPT = { 'r' },
        MORE = { 'rm' },
        CONFIRM = { 'r?' },
        SHELL = { '!' },
        TERMINAL = { 't' },
    }
    local mode_names = {}
    for mode, ms in pairs(modes) do
        for _, m in ipairs(ms) do
            mode_names[m] = mode
        end
    end
    local mode = mode_names[vim.api.nvim_get_mode().mode] or ''
    -- File path
    local filepath = ''
    if vim.api.nvim_buf_get_option(0, 'buftype') ~= 'terminal' then
        filepath = vim.fn.expand '%:p'
        local home = os.getenv 'HOME'
        if filepath:sub(1, #home) == home then
            filepath = '~' .. filepath:sub(#home + 1)
        end
    end
    -- LSP breadcrumbs
    local breadcrumbs = ''
    if #vim.lsp.get_clients { bufnr = 0 } > 0 then
        local location = require 'nvim-navic'.get_location()
        if location ~= '' then
            breadcrumbs = '> ' .. location
        end
    end
    -- Diagnostics
    local diagnostics = ''
    for level, sign in pairs(diagnostic_signs) do
        local level_name = vim.diagnostic.severity[level]
        local count = #vim.diagnostic.get(0, { severity = level })
        if count > 0 then
            diagnostics = diagnostics ..
                ' %#Diagnostic' .. level_name:sub(1, 1):upper() .. level_name:sub(2):lower() .. '#' .. sign .. count
        end
    end
    diagnostics = diagnostics .. '%*'
    -- Git info
    local git_dict = vim.b.gitsigns_status_dict
    local git_info = ''
    if git_dict then
        local added = git_dict.added and git_dict.added > 0 and ('%#Added#+' .. git_dict.added) or ''
        local changed = git_dict.changed and git_dict.changed > 0 and ('%#Changed#~' .. git_dict.changed) or ''
        local removed = git_dict.removed and git_dict.removed > 0 and ('%#Removed#-' .. git_dict.removed) or ''
        git_info = added .. ' ' .. changed .. ' ' .. removed .. ' %* ' .. git_dict.head
    end
    -- Search, file position, file type
    local searchcount = vim.fn.searchcount()
    searchcount = searchcount.current .. '/' .. searchcount.total
    local filetype = vim.bo.filetype:upper()
    local filepos = '%P %l:%c'
    return '%#Statusline#' .. mode .. '%* ' .. filepath .. ' ' .. breadcrumbs .. diagnostics
        .. '%=%*' .. git_info .. ' ' .. searchcount .. ' ' .. filepos .. ' ' .. filetype
end

vim.opt.statusline = [[%!v:lua.Statusline()]]

-- Plugins
-- Bootstrap lazy.nvim and setup plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath
    }
end
vim.opt.rtp:prepend(lazypath)
require 'lazy'.setup {
    { import = 'plugins' }, { import = 'dev' },
}

-- Reload module
function R(name)
    package.loaded[name] = nil
    return require(name)
end
