--------------------
--- Vim options ---
--------------------
local M = {}

function M.set()
    vim.o.number = true -- enable line numbers
    vim.o.ignorecase = true -- when searching
    vim.o.smartcase = true -- don't ignore case if search string contains uppercase letters
    vim.o.compatible = false -- disable vi compatibility
    vim.o.incsearch = true -- incremental searching
    vim.o.visualbell = true -- disable bleeping
    vim.o.expandtab = true -- insert spaces with tab
    vim.o.tabstop = 4 -- width of tab
    vim.o.shiftwidth = 4 -- width of indent
    vim.o.ruler = true -- cursor position in the status line
    vim.o.cursorline = true -- highlight line with cursor
    vim.o.autoindent = true -- apply indentation of the previous line
    vim.o.smartindent = true -- indent based on syntax
    vim.o.hlsearch = false -- do not highlight all search matches
    vim.o.virtualedit = 'all' -- allow virtual editing
    vim.o.backspace = 'indent,eol,start' -- backspace anything in insert mode
    vim.o.mouse = 'a' -- mouse support
    vim.o.autochdir = true -- change working dir to buffer dir
    vim.o.completeopt = 'menuone,noselect' -- required for nvim-cmp
    vim.o.timeoutlen = 250 -- mapping timeout (which-key shows up after it)
    vim.o.hidden = true -- switch between buffers without saving
    vim.o.undofile = true -- persistent undo
    vim.o.backup = false -- disable backup
    vim.o.writebackup = false
    vim.o.scrolloff = 10 -- keep cursor 10 lines from screen edge
    vim.o.termguicolors = true -- prevent warning about opacity changes
    vim.opt.spelllang = { 'en_us', 'pl' } -- check English and Polish spelling

    vim.g.mapleader = ';'
    vim.g.maplocalleader = ';'
end

return M
