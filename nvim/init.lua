---------------
--- Plugins ---
---------------
local Plug = function(plugin, options)
    local arg = "'" .. plugin .. "'"
    if options then
        arg = arg .. ', ' .. options
    end
    vim.cmd.Plug(arg)
end

vim.cmd.call "plug#begin(stdpath('data') . 'plugged')"
-- needed for other plugins
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'

-- picker UI
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug('nvim-telescope/telescope-fzf-native.nvim', "{'do': 'make'}")
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'cljoly/telescope-repo.nvim'
Plug 'crispgm/telescope-heading.nvim'

-- syntax highlighting and other stuff
Plug('nvim-treesitter/nvim-treesitter', "{'do': ':TSUpdate'}")
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

-- LSP utils
Plug 'neovim/nvim-lspconfig'
Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' -- diagnostic lines
Plug 'simrat39/rust-tools.nvim' -- Rust-specific plugin
Plug 'lukas-reineke/lsp-format.nvim' -- auto format
Plug 'SmiteshP/nvim-navic' -- breadcrumbs
Plug 'folke/neodev.nvim' -- LSP for neovim config/plugin dev
Plug 'kosayoda/nvim-lightbulb' -- code action lightbulb
Plug 'smjonas/inc-rename.nvim' -- incremental renaming
Plug 'j-hui/fidget.nvim' -- progress info
Plug 'jubnzv/virtual-types.nvim' -- code lens types

-- completion
Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'f3fora/cmp-spell'

-- git
Plug 'lewis6991/gitsigns.nvim'
Plug 'akinsho/git-conflict.nvim'
Plug 'ruifm/gitlinker.nvim'

-- word/range highlighting
Plug 'NvChad/nvim-colorizer.lua' -- hex color highlighter
Plug 'winston0410/cmd-parser.nvim' -- required for range-highlight
Plug 'winston0410/range-highlight.nvim' -- highlights range entered in cmdline
Plug 'folke/todo-comments.nvim' -- higlight todo comments
Plug 'RRethy/vim-illuminate' -- highlight word under cursor

-- UI improvements
Plug 'nvim-lualine/lualine.nvim' -- statusline
Plug 'kyazdani42/nvim-web-devicons' -- statusline icons
Plug 'folke/which-key.nvim' -- show key mapping hints
Plug 'stevearc/dressing.nvim' -- better select/input menus
Plug 'rcarriga/nvim-notify' -- better notifications
Plug 'lewis6991/hover.nvim' -- better hover

-- theming
Plug 'projekt0n/github-nvim-theme' -- github colors
Plug 'xiyaowong/nvim-transparent'
Plug 'zbirenbaum/neodim'
Plug 'sunjon/Shade.nvim'

-- debugging
Plug 'mfussenegger/nvim-dap' -- debugging integration
Plug 'rcarriga/nvim-dap-ui' -- debug UI
Plug 'theHamsta/nvim-dap-virtual-text' -- display variable values in virtual text

-- copilot
Plug 'https://github.com/zbirenbaum/copilot.lua'
Plug 'https://github.com/zbirenbaum/copilot-cmp'

-- other
Plug 'LnL7/vim-nix' -- nix language support
Plug 'Saecki/crates.nvim' -- cargo file support
--Plug 'mcauley-penney/tidy.nvim' -- trim whitespace
Plug 'lewis6991/spaceless.nvim' -- trim whitespace
Plug 'tpope/vim-eunuch' -- unix commands in vim
Plug 'NMAC427/guess-indent.nvim' -- guess indentation from file
Plug 'simrat39/symbols-outline.nvim'
Plug('toppair/peek.nvim', "{'do': 'deno task --quiet build:fast'}")
vim.cmd.call "plug#end()"

---------------

require 'vim-options'.set()
require 'vim-mappings'.set()
require 'autocmds'.setup()

------------------
--- Keymapping ---
------------------
local wk = require 'which-key'
wk.setup {
    window = {
        border = "single",
        margin = { 4, 4, 4, 4 },
        padding = { 1, 1, 1, 1 },
    },
    layout = {
        align = "center",
    },
}

wk.register({
    q = { ':qa<CR>', 'Quit' },
    Q = { ':qa!<CR>', 'Force quit' },
    w = { ':w<CR>', 'Write current file' },
    W = { ':wa<CR>', 'Write all open files' },
    ['<M-w>'] = { ':w !sudo tee %<CR>', 'Write current file (sudo)' },
},
    { prefix = '<leader>' })

-----------------
--- Telescope ---
-----------------
local telescope = require 'telescope'
telescope.setup {
    defaults = {
        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        -- switch between horizontal/vertical layout based on window size
        layout_strategy = "flex",
        layout_config = {
            flex = { flip_columns = 240 },
            vertical = { width = 0.8, height = 0.9 },
            horizontal = { width = 0.6, height = 0.9 },
        },
        mappings = {
            i = {
                ["<ESC>"] = "close",
                ["<M-j>"] = "move_selection_next",
                ["<M-k>"] = "move_selection_previous",
            },
        },
        file_ignore_patterns = { ".cache", ".clangd" },
    },
    extensions = {
        hijack_netrw = true,
    },
}

telescope.load_extension 'file_browser'
telescope.load_extension 'fzf'
telescope.load_extension 'ui-select'
telescope.load_extension 'gh'
telescope.load_extension 'repo'
telescope.load_extension 'heading'

local telescope_builtin = require 'telescope.builtin'

wk.register({
    ['/'] = { telescope_builtin.current_buffer_fuzzy_find, "Find in current file" },
    ['?'] = { telescope_builtin.live_grep, "Find in files" },
    b = { function() telescope_builtin.buffers { ignore_current_buffer = true, sort_mru = true } end, "Buffers" },
    f = {
        name = "File",
        f = { function() telescope.extensions.file_browser.file_browser { respect_gitignore = false } end, "Browse files" },
        F = { function() telescope_builtin.find_files { hidden = true, follow = true } end, "Find file" },
        r = { telescope_builtin.oldfiles, "Recent files" },
    },
    g = {
        name = "Git",
        g = { telescope.extensions.repo.repo, "Repositories" },
    },
    p = { telescope_builtin.registers, "Paste" },
},
    { prefix = '<leader>' })

-----------------

vim.cmd.colorscheme 'github_light'

require 'syntax'.setup()
require 'langservers'.setup(wk)
require 'completion'.setup()
require 'git'.setup(wk)
require 'statusline'.setup()
require 'notifications'.setup()


require 'colorizer'.setup()
require 'range-highlight'.setup()
require 'todo-comments'.setup()
require 'dressing'.setup {
    input = {
        override = function(conf)
            conf.col = -1
            conf.row = 0
            return conf
        end,
    },
}
require 'neodim'.setup()
require 'transparent'.setup { enable = true }
require 'spaceless'.setup()
require 'guess-indent'.setup()
require 'peek'.setup()
require 'shade'.setup { overlay_opacity = 80 }
require 'fidget'.setup()

require 'symbols-outline'.setup()
wk.register({
        t = { require 'symbols-outline'.toggle_outline, "Symbol tree" }
    },
    { prefix = '<leader>' })

require 'debugging'.setup()
