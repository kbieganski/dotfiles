-- Options
vim.o.autochdir = true                    -- change working dir to buffer dir
vim.o.autowriteall = true                 -- auto save files
vim.o.clipboard = 'unnamedplus'           -- use system clipboard
vim.o.cursorline = true                   -- highlight line with cursor
vim.o.expandtab = true                    -- insert spaces with tab
vim.o.foldenable = false                  -- no code folding
vim.o.hlsearch = false                    -- do not highlight all search matches
vim.o.ignorecase = true                   -- when searching
vim.o.laststatus = 3                      -- single, global statusline
vim.o.linebreak = true                    -- break on whitespace
vim.o.number = true                       -- show line numbers
vim.o.relativenumber = true               -- show relative line numbers
vim.o.shiftwidth = 4                      -- width of indent
vim.o.shortmess = vim.o.shortmess .. 'IS' -- don't show welcome message or search count
vim.o.showmode = false                    -- don't show mode in command line
vim.o.smartcase = true                    -- don't ignore case if search string contains uppercase letters
vim.o.smartindent = true                  -- indent based on syntax
vim.o.spelllang = 'en_us,pl'              -- check English and Polish spelling
vim.o.spell = true                        -- enable spell checking
vim.o.tabstop = 4                         -- width of tab
vim.o.termguicolors = true                -- 24-bit color support
vim.o.undofile = true                     -- persistent undo
vim.o.updatetime = 1000                   -- time for various update events
vim.o.virtualedit = 'all'                 -- allow virtual editing
vim.o.visualbell = true                   -- disable beeping
vim.o.writebackup = false                 -- disable backup when overwriting

-- Diagnostics
local diagnostic_signs = {
    [vim.diagnostic.severity.ERROR] = ' ',
    [vim.diagnostic.severity.WARN] = ' ',
    [vim.diagnostic.severity.INFO] = ' ',
    [vim.diagnostic.severity.HINT] = ' ',
}
vim.diagnostic.config {
    virtual_text = false,
    update_in_insert = true,
    signs = { text = diagnostic_signs }
}

-- Custom filetypes
vim.filetype.add { filename = {
    ['dot-gdbinit'] = 'gdb',
    ['dot-gitconfig'] = 'gitconfig',
    ['dot-gitconfig-work'] = 'gitconfig',
    ['dot-tmux.conf'] = 'tmux',
    ['dot-zprofile'] = 'zsh',
    ['dot-zshrc'] = 'zsh',
    ['dot-zshenv'] = 'zsh',
} }

-- Mappings
vim.g.mapleader = ' '

-- Remap Ctrl-C to Esc, so that InsertLeave gets triggered
vim.keymap.set('n', '<C-c>', '<esc>')

-- Faster save
vim.keymap.set('n', '<leader>w', vim.cmd.w, { desc = 'Write file' })
vim.keymap.set('n', '<leader>W', vim.cmd.wa, { desc = 'Write all files' })

-- Unmap folds
for _, key in ipairs { 'a', 'A', 'c', 'C', 'd', 'D', 'E', 'f', 'i', 'm', 'M', 'o', 'O', 'r', 'R', 'v', 'x' } do
    vim.keymap.set({ 'n', 'v' }, 'z' .. key, function() end, { desc = '' })
end

-- Next, previous error
vim.keymap.set('n', ']e',
    function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR, float = false } end,
    { desc = 'Next error' })
vim.keymap.set('n', '[e',
    function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR, float = false } end,
    { desc = 'Previous error' })

-- Delete without yanking with s/S/x/X
vim.keymap.set({ 'n', 'v' }, 'x', '"-x')
vim.keymap.set({ 'n', 'v' }, 'X', '"-X')
vim.keymap.set({ 'n', 'v' }, 's', '"-xi')
vim.keymap.set('n', 'S', '0"-D')

-- Replace without yanking the replaced text
vim.keymap.set('v', 'p', '"_dP')

-- New keymaps for deleting/replacing without yanking
vim.keymap.set('n', 'zx', '"_dd', { desc = 'Delete line' })
vim.keymap.set('v', 'zx', '"_d', { desc = 'Delete selection' })
vim.keymap.set('n', 'zj', 'o<esc>kj', { desc = 'Insert line below' })
vim.keymap.set('n', 'zk', 'O<esc>jk', { desc = 'Insert line above' })

-- Move up/down on visual lines
vim.keymap.set('n', 'j', "v:count ? 'j' : 'gj'", { expr = true })
vim.keymap.set('n', 'k', "v:count ? 'k' : 'gk'", { expr = true })

-- Move selected lines up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Window management with alt
vim.keymap.set('n', '<M-q>', vim.cmd.close)
vim.keymap.set('n', '<M-b>', vim.cmd.split)
vim.keymap.set('n', '<M-v>', vim.cmd.vsplit)
vim.keymap.set('n', '<M-H>', '<C-w><S-h>')
vim.keymap.set('n', '<M-J>', '<C-w><S-j>')
vim.keymap.set('n', '<M-K>', '<C-w><S-k>')
vim.keymap.set('n', '<M-L>', '<C-w><S-l>')

-- Tab management
vim.keymap.set('n', '<M-t>', vim.cmd.tabnew)
vim.keymap.set('n', '<M-T>', function() vim.cmd.wincmd 'T' end)
vim.keymap.set('n', '<M-Q>', vim.cmd.tabclose, { nowait = true })
vim.keymap.set('n', '<M-.>', vim.cmd.tabnext)
vim.keymap.set('n', '<M-,>', vim.cmd.tabprev)

-- Make < and > keep selection
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Diagnostics
vim.keymap.set('n', '<leader>d', function()
    local win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(win)
    local items = vim.diagnostic.toqflist(vim.diagnostic.get(bufnr))
    vim.fn.setloclist(win, {}, ' ', { title = 'Document diagnostics', items = items })
    if vim.api.nvim_get_current_win() == win and #items > 0 then
        vim.cmd.lopen()
    end
end, { desc = 'Document diagnostics' })
vim.keymap.set('n', '<leader>D',
    function() vim.diagnostic.setqflist { title = 'All diangostics' } end,
    { desc = 'All diagnostics' })

-- Rename current file
vim.keymap.set('n', '<leader>r', function()
    local filename = vim.api.nvim_buf_get_name(0)
    vim.ui.input({ prompt = 'New filename: ', default = filename, completion = 'file' }, function(new_filename)
        if not new_filename or new_filename == '' then return end
        if vim.uv.fs_stat(filename) then
            vim.cmd.write(new_filename)
            vim.cmd.bdelete(1)
            vim.cmd.edit(new_filename)
            vim.fn.delete(filename)
        else
            vim.api.nvim_buf_set_name(0, new_filename)
        end
    end)
end, { desc = 'Rename current file' })

-- Interactive shell commands
local function get_visual_selection()
    if vim.api.nvim_get_mode().mode ~= 'v' then
        return ''
    else
        local _, ls, cs = unpack(vim.fn.getpos 'v')
        local _, le, ce = unpack(vim.fn.getpos '.')
        ls = ls - 1; le = le - 1; cs = cs - 1
        local lines = vim.api.nvim_buf_get_text(0, math.min(ls, le),
            math.min(cs, ce), math.max(ls, le), math.max(cs, ce), {})
        return table.concat(lines, ' ')
    end
end

local function termrun(cmd, fn)
    if vim.fn.reg_recording() ~= '' then
        vim.notify('Cannot do that while recording macro', vim.log.levels.ERROR)
        return
    end
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
            if vim.uv.fs_stat(tempfile) then
                local selected = vim.fn.readfile(tempfile)
                fn(selected)
            end
        end
    })
    vim.cmd.startinsert()
end

local function grep_parse(selected, root)
    local filename, lnum, col, text = selected:match '^(.*):(%d+):(%d+):?(.*)'
    lnum = tonumber(lnum)
    col = tonumber(col) - 1
    return root .. filename, lnum, col, text
end

local function grep_edit_or_qfl(selected, root)
    root = root and root .. '/' or ''
    if #selected == 1 then
        local filename, lnum, col, _ = grep_parse(selected[1], root)
        vim.cmd.edit(filename)
        vim.api.nvim_win_set_cursor(0, { lnum, col })
    elseif #selected > 1 then
        vim.fn.setqflist(vim.tbl_map(
            function(item)
                local filename, lnum, col, text = grep_parse(item, root)
                return { filename = filename, lnum = lnum, col = col, text = text }
            end, selected))
        vim.cmd.copen()
    end
end

local function fzf_cmd(opts)
    opts = opts or {}
    opts.history = opts.history or true
    return 'fzf --multi --query ' .. vim.fn.shellescape(get_visual_selection())
        .. ' --preview "bat {} --color=always" --preview-window="<80(up)" '
        .. (opts.history and '--history=' .. vim.fn.stdpath 'data' .. '/fzf-history' or '')
end

local function edit_or_qfl(selected, root)
    root = root and root .. '/' or ''
    if #selected == 1 then
        vim.cmd.edit(root .. selected[1])
    elseif #selected > 1 then
        vim.fn.setqflist(vim.tbl_map(function(item) return { filename = root .. item } end, selected))
        vim.cmd.copen()
    end
end

local function git_root()
    return vim.system { 'git', 'get-root' }:wait().stdout
end

local function fzg_cmd()
    return 'fzg --multi --query ' .. vim.fn.shellescape(get_visual_selection())
        .. ' --history=' .. vim.fn.stdpath 'data' .. '/fzg-history'
end

vim.keymap.set('n', '<leader>o',
    function()
        local current_buf = vim.api.nvim_get_current_buf()
        local buf_map = {}
        local buffers = vim.iter(vim.fn.getjumplist()[1]):rev()
            :map(function(jump) return jump.bufnr end)
            :filter(function(b)
                if buf_map[b] then return false end
                if not vim.api.nvim_buf_is_loaded(b) then return false end
                local name = vim.api.nvim_buf_get_name(b)
                if name == '' then return false end
                buf_map[b] = name
                return b ~= current_buf and vim.api.nvim_get_option_value('buftype', { buf = b }) == ''
            end)
            :map(function(b) return buf_map[b] end):totable()
        buf_map = vim.iter(pairs(buf_map))
            :fold({}, function(tbl, b, f)
                tbl[f] = b
                return tbl
            end)
        local oldfiles = vim.iter(vim.v.oldfiles)
            :filter(function(f) return vim.uv.fs_stat(f) and not buf_map[f] end)
            :totable()
        local files = vim.iter { buffers, oldfiles }:flatten()
            :filter(function(f) return f:sub(#f - 18, #f) ~= '.git/COMMIT_EDITMSG' end)
            :filter(function(f) return f:sub(1, 9) ~= '/tmp/tmp.' end)
            :join '\n'
        termrun('echo ' .. vim.fn.shellescape(files) .. ' | ' .. fzf_cmd { history = false }, edit_or_qfl)
    end,
    { desc = 'Old files' })

vim.keymap.set('n', '<leader>f',
    function() termrun('lf -print-selection ' .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0)), edit_or_qfl) end,
    { desc = 'File browser' })

vim.keymap.set({ 'n', 'v' }, '|', function() termrun(fzf_cmd(), edit_or_qfl) end, { desc = 'Find file' })
vim.keymap.set({ 'n', 'v' }, '<M-|>',
    function() termrun(fzf_cmd() .. ' --bind load:prev-history', edit_or_qfl) end,
    { desc = 'Find file' })

vim.keymap.set({ 'n', 'v' }, '<leader>|',
    function() termrun('git ' .. fzf_cmd(), function(selected) edit_or_qfl(selected, git_root()) end) end,
    { desc = 'Find file in repository' })
vim.keymap.set({ 'n', 'v' }, '<leader><M-|>',
    function()
        termrun('git ' .. fzf_cmd() .. ' --bind load:prev-history',
            function(selected) edit_or_qfl(selected, git_root()) end)
    end,
    { desc = 'Find file in repository' })

vim.keymap.set({ 'n', 'v' }, '\\', function() termrun(fzg_cmd(), grep_edit_or_qfl) end, { desc = 'Grep files' })
vim.keymap.set({ 'n', 'v' }, '<M-\\>',
    function() termrun(fzg_cmd() .. ' --bind load:prev-history', grep_edit_or_qfl) end,
    { desc = 'Grep files' })

vim.keymap.set({ 'n', 'v' }, '<leader>\\',
    function() termrun('git ' .. fzg_cmd(), grep_edit_or_qfl) end,
    { desc = 'Grep repository' })
vim.keymap.set({ 'n', 'v' }, '<leader><M-\\>',
    function() termrun('git ' .. fzg_cmd() .. ' --bind load:prev-history', grep_edit_or_qfl) end,
    { desc = 'Grep repository' })

vim.keymap.set('n', '<leader>n', function() termrun('note', edit_or_qfl) end, { desc = 'Note find' })
vim.keymap.set('n', '<leader>N', function() termrun('note --grep', grep_edit_or_qfl) end, { desc = 'Note grep' })

-- Undotree
local function undotree()
    local tree = vim.fn.undotree()
    local entries = tree.entries
    if not entries then
        return
    end
    local i = 1
    while i <= #entries do
        local entry = entries[i]
        entry.level = entry.level or 1
        for j, child_entry in ipairs(entry.alt or {}) do
            child_entry.level = entry.level + 1
            child_entry.last = j == #entry.alt
            table.insert(entries, i + j - 1, child_entry)
        end
        i = entry.alt and i or i + 1
        entry.alt = nil
    end
    entries[#entries].last = true
    entries = vim.iter(entries):rev():totable()
    vim.ui.select(entries, {
        prompt = 'Undo',
        format_item = function(entry)
            local dt = os.time() - entry.time
            local ago
            if dt < 60 then
                ago = math.floor(dt) .. 's ago'
            elseif dt < 3600 then
                ago = math.floor(dt / 60) .. 'm ago'
            elseif dt < 24 * 3600 then
                ago = math.floor(dt / 3600) .. 'h ago'
            else
                ago = math.floor(dt / (24 * 3600)) .. 'd ago'
            end
            local prefix = (' │ '):rep(entry.level - 1) .. (entry.last and ' ┌─' or ' ├─')
            local caret = entry.seq == tree.seq_cur and '⮜' or ''
            return string.format('%s#%d (%s) %s', prefix, entry.seq, ago, caret)
        end,
    }, function(choice)
        if choice then
            vim.cmd('undo ' .. choice.seq)
        end
    end)
end
vim.keymap.set('n', '<leader>u', undotree, { desc = 'Undo tree' })

-- Autocmds
-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained' }, {
    callback = function() vim.cmd.checktime() end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank { higroup = 'Search' } end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd('VimResized', {
    callback = function() vim.cmd.tabdo 'wincmd =' end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Replace netrw with lf
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    callback = function(ev)
        if vim.bo.buftype == 'term' then
            return
        end
        local path = vim.api.nvim_buf_get_name(ev.buf)
        if vim.fn.isdirectory(path) == 1 then
            vim.api.nvim_buf_delete(ev.buf, { force = true })
            termrun('lf -print-selection ' .. path, edit_or_qfl)
        end
    end,
})

-- Inserts given URL as Markdown link at cursor position
local function insert_markdown_link(url)
    if not url or url == '' then return end
    local html = vim.system({ 'curl', '-L', url, }, { stderr = false }):wait().stdout
    assert(type(html) == 'string')
    local title = html:match('<title>(.-)</title>') or 'Untitled'
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local new_line = string.format('%s[%s](%s)%s', line:sub(0, pos), title, url, line:sub(pos + 1))
    vim.api.nvim_set_current_line(new_line)
end

-- Markdown-specific settings:
-- - conceal links
-- - paste link with title using <leader>l
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function(e)
        vim.opt_local.conceallevel = 2 -- conceal links
        vim.keymap.set('n', '<leader>l',
            function()
                local clipboard = vim.fn.getreg '+'
                if clipboard:match '^https?://' then
                    insert_markdown_link(clipboard)
                else
                    vim.ui.input({ prompt = 'URL: ' }, insert_markdown_link)
                end
            end,
            { buffer = e.buf, desc = 'Insert link' })
        vim.keymap.set('v', '<leader>l',
            function()
                local selected = get_visual_selection()
                if selected:match '^https?://' then
                    vim.cmd 'normal! x'
                    insert_markdown_link(selected)
                end
            end,
            { buffer = e.buf, desc = 'Turn into link' })
    end
})

-- Statusline
local modes = {}
for mode, ms in pairs {
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
} do
    for _, m in ipairs(ms) do modes[m] = mode end
end

function Statusline()
    -- Mode
    local mode = modes[vim.api.nvim_get_mode().mode] or ''
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
    diagnostics = diagnostics .. '%* '
    -- Git info
    local git_dict = vim.b.gitsigns_status_dict
    local git_info = ''
    if git_dict then
        local added = git_dict.added and git_dict.added > 0 and ('%#Added#+' .. git_dict.added) or ''
        local changed = git_dict.changed and git_dict.changed > 0 and ('%#Changed#~' .. git_dict.changed) or ''
        local removed = git_dict.removed and git_dict.removed > 0 and ('%#Removed#-' .. git_dict.removed) or ''
        git_info = '  ' .. git_dict.head .. ' ' .. added .. ' ' .. changed .. ' ' .. removed .. '%* '
    end
    -- Search, file position, file type
    local searchcount = vim.fn.searchcount()
    searchcount = searchcount.current .. '/' .. searchcount.total
    local filepos = ' %P %l:%c'
    return '%#Statusline#' .. mode .. diagnostics .. git_info .. '%=%*' .. searchcount .. filepos
end

vim.go.statusline = [[%!v:lua.Statusline()]]

-- Plugins
-- Bootstrap lazy.nvim and setup plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
end
vim.opt.rtp:prepend(lazypath)
require 'lazy'.setup {
    spec = { { import = 'plugins' }, { import = 'dev' } },
    dev = {
        path = '~/proj',
        fallback = true,
    },
    install = {
        colorscheme = { 'austere-theme' },
    },
    ui = { border = 'single' }
}
