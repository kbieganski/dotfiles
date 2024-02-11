-- Vim options
--------------
local M = {}

function M.set()
    vim.o.clipboard = 'unnamedplus' -- use system clipboard
    vim.o.number = true             -- enable line numbers
    vim.o.ignorecase = true         -- when searching
    vim.o.smartcase = true          -- don't ignore case if search string contains uppercase letters
    vim.o.compatible = false        -- disable vi compatibility
    vim.o.visualbell = true         -- disable bleeping
    vim.o.expandtab = true          -- insert spaces with tab
    vim.o.tabstop = 4               -- width of tab
    vim.o.shiftwidth = 4            -- width of indent
    vim.o.cursorline = true         -- highlight line with cursor
    vim.o.smartindent = true        -- indent based on syntax
    vim.o.hlsearch = false          -- do not highlight all search matches
    vim.o.virtualedit = 'all'       -- allow virtual editing
    vim.o.mouse = 'a'               -- mouse support
    vim.o.autochdir = true          -- change working dir to buffer dir
    vim.o.pumheight = 10            -- limit shown completion items
    vim.o.timeoutlen = 250          -- mapping timeout
    vim.o.updatetime = 1000
    vim.o.undofile = true           -- persistent undo
    vim.o.writebackup = false       -- disable backup when overwriting
    vim.o.scrolloff = 10            -- keep cursor 10 lines from screen edge
    vim.o.termguicolors = true      -- 24-bit color support
    vim.o.spelllang = 'en_us,pl'    -- check English and Polish spelling
    vim.o.spell = true
    vim.o.foldenable = false
    vim.o.relativenumber = true
    vim.wo.conceallevel = 2
    vim.opt.signcolumn = 'yes:2'
end

return M
