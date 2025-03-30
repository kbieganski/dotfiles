-- Options
vim.o.autochdir        = true -- change working dir to buffer dir
vim.o.autowriteall     = true -- auto save files on many commands
vim.o.clipboard        = 'unnamedplus' -- use system clipboard
vim.o.completeopt      = 'menuone,noinsert' -- always display completion menu, do not auto insert
vim.o.cursorline       = true -- highlight line with cursor
vim.o.expandtab        = true -- insert spaces with tab
vim.o.fillchars        = 'stl:─' -- fill statusline with horizontal line
vim.o.foldlevelstart   = 99 -- expand folds initially
vim.o.ignorecase       = true -- when searching
vim.o.laststatus       = 3 -- single, global statusline
vim.o.linebreak        = true -- break on whitespace
vim.o.mousemoveevent   = true -- trigger CursorMoved on mouse move
vim.o.number           = true -- show line numbers
vim.o.relativenumber   = true -- show relative line numbers
vim.o.shada            = "!,'1000,<50,s10,h" -- default except 1000 oldfiles
vim.o.shiftwidth       = 4 -- width of indent
vim.o.shortmess        = vim.o.shortmess .. 'IS' -- don't show welcome message or search count
vim.o.showmode         = false -- don't show mode in command line
vim.o.smartcase        = true -- don't ignore case if search string contains uppercase letters
vim.o.smartindent      = true -- indent based on syntax
vim.o.spell            = true -- enable spell checking
vim.o.spellfile        = os.getenv 'HOME' .. '/sync/spellfile.utf-8.add'
vim.o.spelllang        = 'en_us,pl' -- check English and Polish spelling
vim.o.tabstop          = 4 -- width of tab
vim.o.termguicolors    = true -- 24-bit color support
vim.o.undofile         = true -- persistent undo
vim.o.updatetime       = 1000 -- time for various update events
vim.o.virtualedit      = 'all' -- allow virtual editing
vim.o.visualbell       = true -- disable beeping
vim.o.winborder        = 'single' -- single border on all windows by default
vim.o.writebackup      = false -- disable backup when overwriting

-- Diagnostics
local diagnostic_signs = {
    [vim.diagnostic.severity.ERROR] = ' ',
    [vim.diagnostic.severity.WARN] = ' ',
    [vim.diagnostic.severity.INFO] = ' ',
    [vim.diagnostic.severity.HINT] = ' ',
}
vim.diagnostic.config {
    update_in_insert = true,
    signs = { text = diagnostic_signs },
    severity_sort = true,
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

-- Next, previous error
vim.keymap.set('n', ']e',
    function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = false } end,
    { desc = 'Next error' })
vim.keymap.set('n', '[e',
    function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR, float = false } end,
    { desc = 'Previous error' })

-- Delete without yanking with s/S/x/X
vim.keymap.set({ 'n', 'v' }, 'x', '"-x')
vim.keymap.set({ 'n', 'v' }, 'X', '"-X')
vim.keymap.set({ 'n', 'v' }, 's', '"-xi')
vim.keymap.set('n', 'S', '0"-D')

-- Replace without yanking the replaced text
vim.keymap.set('v', 'p', '"_dP')

-- New keymaps for deleting/replacing without yanking
vim.keymap.set('n', '<M-x>', '"_dd', { desc = 'Delete line' })
vim.keymap.set('v', 'x', '"_d', { desc = 'Delete selection' })
vim.keymap.set('v', 'X', '"_D', { desc = 'Delete selected lines' })

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

-- Toggle line wrapping
vim.keymap.set('n', '<leader>w', function() vim.o.wrap = not vim.o.wrap end, { desc = 'Toggle line wrapping' })

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
    function() vim.diagnostic.setqflist { title = 'All diagnostics' } end,
    { desc = 'All diagnostics' })

-- Rename current file
vim.keymap.set('n', '<leader>r', function()
    local filename = vim.api.nvim_buf_get_name(0)
    vim.ui.input({ prompt = 'New Filename: ', default = filename, completion = 'file' }, function(new_filename)
        if not new_filename or new_filename == '' then return end
        if vim.uv.fs_stat(filename) then
            vim.cmd.bdelete()
            vim.uv.fs_rename(filename, new_filename, vim.schedule_wrap(function()
                vim.cmd.edit(new_filename)
            end))
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

local function term_result(cmd, fn)
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
    vim.fn.jobstart(cmd .. ' > ' .. tempfile, {
        term = true,
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
    opts.start_history = opts.start_history or false
    return 'fzf --multi --query ' .. vim.fn.shellescape(get_visual_selection())
        .. ' --preview "bat {} --color=always" --preview-window="<80(up)" '
        .. (opts.history and '--history=' .. vim.fn.stdpath 'data' .. '/fzf-history' or '')
        .. (opts.start_history and ' --bind start:prev-history' or '')
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

-- Global function that opens lf
function Lf(path)
    term_result('lf -print-selection ' .. vim.fn.shellescape(path), edit_or_qfl)
end

local function git_root()
    return vim.system { 'git', 'get-root' }:wait().stdout
end

local function fzg_cmd(opts)
    opts = opts or {}
    opts.start_history = opts.start_history or false
    return 'fzg --multi --query ' .. vim.fn.shellescape(get_visual_selection())
        .. ' --history=' .. vim.fn.stdpath 'data' .. '/fzg-history'
        .. (opts.start_history and ' --bind start:prev-history' or '')
end

vim.keymap.set('n', '<leader>o',
    function()
        local current_buf = vim.api.nvim_get_current_buf()
        local buf_map = {}
        local buffers = vim.iter(vim.fn.getjumplist()[1]):rev()
            :map(function(jump) return jump.bufnr end)
            :filter(function(bufnr)
                if buf_map[bufnr] then return false end
                if not vim.api.nvim_buf_is_loaded(bufnr) then return false end
                local name = vim.api.nvim_buf_get_name(bufnr)
                if name == '' then return false end
                buf_map[bufnr] = name
                return bufnr ~= current_buf and vim.bo[bufnr].buflisted
            end)
            :map(function(b) return buf_map[b] end):totable()
        buf_map = vim.iter(pairs(buf_map)):fold({}, function(tbl, bufnr, filename)
            tbl[filename] = bufnr
            return tbl
        end)
        local oldfiles = vim.iter(vim.v.oldfiles)
            ---@diagnostic disable-next-line: return-type-mismatch
            :filter(function(f) return not buf_map[f] and vim.uv.fs_stat(f) end)
            :totable()
        local cache_dir = os.getenv 'HOME' .. '/.cache/nvim/'
        local scratch_dir = os.getenv 'HOME' .. '/.local/share/nvim/scratch/'
        local files = vim.iter { buffers, oldfiles }:flatten()
            :filter(function(f)
                return
                    f:sub(#f - 18, #f) ~= '.git/COMMIT_EDITMSG'
                    and f:sub(1, #cache_dir) ~= cache_dir
                    and f:sub(1, #scratch_dir) ~= scratch_dir
                    and f:sub(1, 9) ~= '/tmp/tmp.'
            end)
            :join '\n'
        term_result('echo ' .. vim.fn.shellescape(files) .. ' | ' .. fzf_cmd { history = false }, edit_or_qfl)
    end,
    { desc = 'Old files' })

vim.keymap.set('n', '<leader>f', function() Lf(vim.api.nvim_buf_get_name(0)) end, { desc = 'File browser' })

vim.keymap.set({ 'n', 'v' }, '|', function() term_result(fzf_cmd(), edit_or_qfl) end, { desc = 'Find file' })
vim.keymap.set({ 'n', 'v' }, '<M-|>',
    function() term_result(fzf_cmd { start_history = true }, edit_or_qfl) end,
    { desc = 'Find file' })

vim.keymap.set({ 'n', 'v' }, '<leader>|',
    function() term_result('git ' .. fzf_cmd(), function(selected) edit_or_qfl(selected, git_root()) end) end,
    { desc = 'Find file in repository' })
vim.keymap.set({ 'n', 'v' }, '<leader><M-|>',
    function()
        term_result('git ' .. fzf_cmd { start_history = true },
            function(selected) edit_or_qfl(selected, git_root()) end)
    end,
    { desc = 'Find file in repository' })

vim.keymap.set({ 'n', 'v' }, '\\', function() term_result(fzg_cmd(), grep_edit_or_qfl) end, { desc = 'Grep files' })
vim.keymap.set({ 'n', 'v' }, '<M-\\>',
    function() term_result(fzg_cmd { start_history = true }, grep_edit_or_qfl) end,
    { desc = 'Grep files' })

vim.keymap.set({ 'n', 'v' }, '<leader>\\',
    function() term_result('git ' .. fzg_cmd(), grep_edit_or_qfl) end,
    { desc = 'Grep repository' })
vim.keymap.set({ 'n', 'v' }, '<leader><M-\\>',
    function() term_result('git ' .. fzg_cmd { start_history = true }, grep_edit_or_qfl) end,
    { desc = 'Grep repository' })

vim.keymap.set('n', '<leader>n', function() term_result('note', edit_or_qfl) end, { desc = 'Note find' })
vim.keymap.set('n', '<leader>N', function() term_result('note --grep', grep_edit_or_qfl) end, { desc = 'Note grep' })

-- Autocmds
-- Autosave
local autosave_timer = vim.loop.new_timer()
local function write_buf_if_exists(bufnr)
    if vim.fn.mode() == 'i' then return end
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr)) then
        vim.api.nvim_buf_call(bufnr, function() vim.cmd 'silent! write' end)
    end
end

vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'CursorMoved', 'CursorMovedI' }, {
    nested = true,
    callback = function(e)
        if vim.bo[e.buf].buflisted and vim.bo[e.buf].modified then
            ---@diagnostic disable-next-line: need-check-nil
            autosave_timer:start(2000, 0, vim.schedule_wrap(function() write_buf_if_exists(e.buf) end))
        end
    end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave', 'VimSuspend', 'VimLeave', 'FocusLost' }, {
    nested = true,
    callback = function(e)
        if vim.bo[e.buf].buflisted and vim.bo[e.buf].modified then
            ---@diagnostic disable-next-line: need-check-nil
            autosave_timer:stop()
            write_buf_if_exists(e.buf)
        end
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained' }, {
    callback = function() vim.cmd.checktime() end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
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
    callback = function(e)
        if vim.bo.buftype == 'term' then return end
        local path = vim.api.nvim_buf_get_name(e.buf)
        if vim.fn.isdirectory(path) == 1 then
            vim.api.nvim_buf_delete(e.buf, { force = true })
            Lf(path)
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
        vim.opt_local.conceallevel = 1
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


-- No spellcheck in quickfix
vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'qf',
    callback = function()
        vim.api.nvim_set_option_value('spell', false, { scope = 'local', win = 0 })
    end,
})

-- Auto-highlight search
vim.on_key(function(char)
    local key = vim.fn.keytrans(char)
    local keys = { '<CR>', 'n', 'N', '*', '#', '?', '/' }
    local modes = { 'n', 'v', 'V', '' }
    if vim.tbl_contains(modes, vim.fn.mode()) then
        vim.o.hlsearch = vim.tbl_contains(keys, key)
    end
end)

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
    local ok, statusline = pcall(function()
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
            git_info = '  ' .. git_dict.head .. ' ' .. added .. ' ' .. changed .. ' ' .. removed .. '%* '
        end
        -- Search, file position, auto-formatting
        local searchcount = vim.fn.searchcount()
        searchcount = searchcount.current .. '/' .. searchcount.total
        local filepos = ' %P %l:%c'
        local flags = ' ' .. (vim.o.wrap and 'W' or '') ..
            (vim.b.autoformat and 'F' or '') ..
            (vim.lsp.inlay_hint.is_enabled() and 'I' or '') .. ' '
        return '%#Statusline#' .. mode .. diagnostics .. git_info .. '%=%*' .. flags .. searchcount .. filepos
    end)
    return ok and statusline or ''
end

vim.o.statusline = [[%!v:lua.Statusline()]]

-- Replay debugging
local function term_show(file, split)
    local buf = vim.api.nvim_create_buf(false, true)
    local prev_win = vim.api.nvim_get_current_win()
    if split then vim.cmd.vsplit() end
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_set_option_value('number', false, { scope = 'local', win = 0 })
    vim.api.nvim_set_option_value('relativenumber', false, { scope = 'local', win = 0 })
    vim.api.nvim_set_option_value('spell', false, { scope = 'local', win = 0 })
    vim.fn.jobstart("trap -- '' SIGINT; touch " .. file .. '; tail -F ' .. file, {
        term = true,
        on_exit = function()
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    })
    if split then vim.api.nvim_set_current_win(prev_win) end
    return win
end

vim.cmd.packadd 'termdebug'

local function replay_debug()
    local tempfile = vim.fn.tempname()
    local win = term_show(tempfile, true)
    vim.g.termdebugger = { 'rr', 'replay', '-d', 'rust-gdb', '--' }
    vim.g.termdebugdw = win
    vim.cmd.Termdebug()
    vim.fn.TermDebugSendCommand('dashboard -output ' .. tempfile)
    vim.fn.TermDebugSendCommand('dashboard -style discard_scrollback True')
    vim.fn.TermDebugSendCommand('shell clear')
    vim.cmd.Program()
    vim.cmd.hide()
    vim.cmd.stopinsert()
end

vim.keymap.set('n', '<leader><CR>', replay_debug, { desc = 'Replay debugging' })

vim.api.nvim_create_autocmd('User', {
    pattern = 'TermdebugStartPost',
    callback = function()
        vim.keymap.del('n', '<leader><CR>')
        vim.keymap.set('n', '<CR>b', vim.cmd.Break, { desc = 'Toggle breakpoint' })
        vim.keymap.set('n', '<CR>B', vim.cmd.Tbreak, { desc = 'Temporary breakpoint' })
        vim.keymap.set('n', '<CR>C', function() vim.fn.TermDebugSendCommand('reverse-continue') end,
            { desc = 'Reverse continue' })
        vim.keymap.set('n', '<CR>c', vim.cmd.Continue, { desc = 'Continue' })
        vim.keymap.set('n', '<CR>u', vim.cmd.Until, { desc = 'Continue until' })
        vim.keymap.set('n', '<CR>x', vim.cmd.Stop, { desc = 'Stop execution' })
        vim.keymap.set({ 'n', 'v' }, '<CR>v', vim.cmd.Evaluate, { desc = 'Evaluate expression' })
        vim.keymap.set('n', '<C-k>', function() vim.fn.TermDebugSendCommand('reverse-next') end,
            { desc = 'Reverse next statement' })
        vim.keymap.set('n', '<C-j>', vim.cmd.Over, { desc = 'Next statement' })
        vim.keymap.set('n', '<CR>F', function() vim.fn.TermDebugSendCommand('reverse-finish') end,
            { desc = 'Reverse finish frame' })
        vim.keymap.set('n', '<CR>f', vim.cmd.Finish, { desc = 'Finish frame' })
        vim.keymap.set('n', '<C-h>', function() vim.fn.TermDebugSendCommand('reverse-step') end,
            { desc = 'Step backwards' })
        vim.keymap.set('n', '<C-l>', vim.cmd.Step, { desc = 'Step forwards' })
        vim.keymap.set('n', '<CR>I', function() vim.fn.TermDebugSendCommand('reverse-stepi') end,
            { desc = 'Step backwards by instruction' })
        vim.keymap.set('n', '<CR>i', function() vim.fn.TermDebugSendCommand('stepi') end,
            { desc = 'Step forwards by instruction' })
    end
})
vim.api.nvim_create_autocmd('User', {
    pattern = 'TermdebugStopPost',
    callback = function()
        if vim.api.nvim_win_is_valid(vim.g.termdebugdw) then
            vim.api.nvim_win_close(vim.g.termdebugdw, true)
        end
        vim.keymap.set('n', '<leader><CR>', replay_debug, { desc = 'Replay debugging' })
        vim.keymap.del('n', '<CR>b')
        vim.keymap.del('n', '<CR>B')
        vim.keymap.del('n', '<CR>C')
        vim.keymap.del('n', '<CR>c')
        vim.keymap.del('n', '<CR>u')
        vim.keymap.del('n', '<CR>x')
        vim.keymap.del({ 'n', 'v' }, '<CR>v')
        vim.keymap.del('n', '<C-k>')
        vim.keymap.del('n', '<C-j>')
        vim.keymap.del('n', '<C-h>')
        vim.keymap.del('n', '<C-l>')
        vim.keymap.del('n', '<CR>f')
        vim.keymap.del('n', '<CR>F')
        vim.keymap.del('n', '<CR>i')
        vim.keymap.del('n', '<CR>I')
    end
})

-- Auto insert mode in termdebug
vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'termdebug',
    callback = function(e)
        vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
            buffer = e.buf,
            callback = function() vim.cmd.startinsert() end,
        })
    end,
})

-- Plugins
-- Bootstrap lazy.nvim and setup plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
        :wait()
end
vim.opt.rtp:prepend(lazypath)
require 'lazy'.setup {
    spec = { { import = 'plugins' } },
    dev = {
        path = '~/proj',
        fallback = true,
    },
    install = {
        colorscheme = { 'austere-theme' },
    },
    ui = { border = 'single' }
}
