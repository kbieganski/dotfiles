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
    Plug 'nvim-telescope/telescope-dap.nvim'
    Plug 'cljoly/telescope-repo.nvim'
    Plug 'crispgm/telescope-heading.nvim'

    -- syntax highlighting
    Plug('nvim-treesitter/nvim-treesitter', "{'do': ':TSUpdate'}")
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'

    -- LSP utils
    Plug 'neovim/nvim-lspconfig'
    Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' -- diagnostic lines
    Plug 'simrat39/rust-tools.nvim'
    Plug 'lukas-reineke/lsp-format.nvim' -- auto format
    Plug 'SmiteshP/nvim-navic' -- breadcrumbs
    Plug 'folke/neodev.nvim'

    -- completion
    Plug 'onsails/lspkind-nvim'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-nvim-lua'
    Plug 'hrsh7th/nvim-cmp'

    -- git
    Plug 'lewis6991/gitsigns.nvim'
    Plug('akinsho/git-conflict.nvim', "{ 'tag': 'v1.0.0' }")

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

    -- other
    Plug 'LnL7/vim-nix' -- nix language support
    Plug 'Saecki/crates.nvim' -- cargo file support
    Plug 'mcauley-penney/tidy.nvim' -- trim whitespace
    Plug 'tpope/vim-eunuch' -- unix commands in vim
    Plug 'mfussenegger/nvim-dap' -- debugging
    Plug 'rcarriga/nvim-dap-ui' -- debugging
    Plug 'NMAC427/guess-indent.nvim' -- guess indentation from file
vim.cmd.call "plug#end()"

------------------------
--- General settings ---
------------------------
vim.o.number = true  -- enable line numbers
vim.o.ignorecase = true  -- when searching
vim.o.smartcase = true  -- don't ignore case if search string contains uppercase letters
vim.o.compatible = false  -- disable vi compatibility
vim.o.incsearch = true  -- incremental searching
vim.o.visualbell = true  -- disable bleeping
vim.o.expandtab = true  -- insert spaces with tab
vim.o.tabstop = 4  -- width of tab
vim.o.shiftwidth = 4  -- width of indent
vim.o.ruler = true  -- cursor position in the status line
vim.o.cursorline = true  -- highlight line with cursor
vim.o.autoindent = true  -- apply indentation of the previous line
vim.o.smartindent = true  -- indent based on syntax
vim.o.hlsearch = false  -- do not highlight all search matches
vim.o.virtualedit = 'all'  -- allow virtual editing
vim.o.backspace = 'indent,eol,start'  -- backspace anything in insert mode
vim.o.mouse = 'a'  -- mouse support
vim.o.autochdir = true  -- change working dir to buffer dir
vim.o.completeopt = 'menuone,noselect'  -- required for nvim-cmp
vim.o.timeoutlen = 250  -- mapping timeout (which-key shows up after it)
vim.o.hidden = true  -- switch between buffers without saving
vim.o.undofile = true  -- persistent undo
vim.o.backup = false  -- disable backup
vim.o.writebackup = false
vim.o.scrolloff = 10  -- keep cursor 10 lines from screen edge
vim.o.termguicolors = true  -- prevent warning about opacity changes

vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

----------------
--- Mappings ---
----------------

-- browse headings
vim.cmd.nnoremap 'gh :Telescope heading<CR>'

-- use system clilpboard by default
vim.cmd.nnoremap 'y "+y'
vim.cmd.nnoremap 'p "+p'
vim.cmd.nnoremap 'P "+P'

-- delete without yanking
vim.cmd.nnoremap 'd "_d'
vim.cmd.vnoremap 'd "_d'

-- use system clilpboard by default, and
-- replace currently selected text with default register
-- without yanking it
vim.cmd.vnoremap 'y "+y'
vim.cmd.vnoremap 'p "_d"+P'
vim.cmd.vnoremap 'P "_d"+P'

-- move up/down on visual lines
vim.cmd.nnoremap "<expr> j v:count ? 'j' : 'gj'"
vim.cmd.nnoremap "<expr> k v:count ? 'k' : 'gk'"

-- window managment with the alt key
vim.cmd.nnoremap '<M-q> <C-w>q'
vim.cmd.nnoremap '<M-c> <C-w>s'
vim.cmd.nnoremap '<M-v> <C-w>v'
vim.cmd.nnoremap '<M-h> <C-w>h'
vim.cmd.nnoremap '<M-j> <C-w>j'
vim.cmd.nnoremap '<M-k> <C-w>k'
vim.cmd.nnoremap '<M-l> <C-w>l'
vim.cmd.nnoremap '<M-S-h> <C-w><S-h>'
vim.cmd.nnoremap '<M-S-j> <C-w><S-j>'
vim.cmd.nnoremap '<M-S-k> <C-w><S-k>'
vim.cmd.nnoremap '<M-S-l> <C-w><S-l>'

-- faster scrolling
vim.cmd.noremap 'J <C-e><C-e>'
vim.cmd.noremap 'K <C-y><C-y>'

-- move through jump history
vim.cmd.noremap 'H <C-o>'
vim.cmd.noremap 'L <C-i>'

-- make < > shifts keep selection
vim.cmd.vnoremap '< <gv'
vim.cmd.vnoremap '> >gv'


-------------------
--- Line length ---
-------------------

vim.cmd.au 'BufRead,BufNewFile *.md setlocal textwidth=80'
vim.cmd.colorscheme 'github_dark'  -- after lualine setup

--------------------------
--- Snippet navigation ---
--------------------------

vim.cmd.imap "<expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'"
vim.cmd.smap "<expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'"
vim.cmd.imap "<expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'"
vim.cmd.smap "<expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'"
vim.cmd.imap "<expr> <M-l>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<M-l>'"
vim.cmd.smap "<expr> <M-l>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<M-l>'"
vim.cmd.imap "<expr> <M-h> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<M-h>'"
vim.cmd.smap "<expr> <M-h> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<M-h>'"

-----------------
--- Which-key ---
-----------------
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

-----------------
--- Telescope ---
-----------------
telescope = require 'telescope'
telescope.setup {
    defaults = {
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
telescope.load_extension 'dap'

telescope_builtin = require 'telescope.builtin'
telescope_utils = require 'telescope.utils'

wk.register({
        ['/'] = { telescope_builtin.current_buffer_fuzzy_find, "Find in current file" },
        ['?'] = { telescope_builtin.live_grep, "Find in files" },
        b = { function() telescope_builtin.buffers{ignore_current_buffer=true, sort_mru=true} end, "Buffers" },
        d = { vim.diagnostic.open_float, "Show this diagnostic" },
        D = { telescope_builtin.diagnostics, "All diagnostics" },
        f = {
            name = "File",
            f = { function() telescope.extensions.file_browser.file_browser { respect_gitignore = false } end, "Browse files" },
            F = { function() telescope_builtin.find_files { hidden = true, follow = true } end, "Find file" },
            r = { telescope_builtin.oldfiles, "Recent files" },
        },
        g = {
            name = "Git",
            c = { telescope_builtin.git_bcommits, "Current file history" },
            C = { telescope_builtin.git_commits, "Repo history" },
            f = { telescope_builtin.git_files, "Find file" },
            g = { telescope.extensions.repo.repo, "Repositories" },
        },
        G = {
            name = "GitHub",
            a = { telescope.extensions.gh.issues, "Action runs" },
            i = { telescope.extensions.gh.issues, "Issues" },
            p = { telescope.extensions.gh.pull_request, "Pull requests" },
            x = { telescope.extensions.gh.gist, "Gist" },
        },
        p = { telescope_builtin.registers, "Paste" },
        q = { ':qa<CR>', 'Quit' },
        Q = { ':qa!<CR>', 'Force quit' },
        w = { ':w<CR>', 'Write current file' },
        W = { ':wa<CR>', 'Write all open files' },
        ['<M-w>'] = { ':w !sudo tee %<CR>', 'Write current file (sudo)' },
    },
    { prefix = '<leader>' })

------------------
--- Spellcheck ---
------------------
vim.opt.spell = true
vim.opt.spelllang = { 'en_us', 'pl' }

------------------
--- Treesitter ---
------------------
require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "glsl",
        "go",
        "haskell",
        "html",
        "javascript",
        "lua",
        "python",
        "regex",
        "rust",
        "typescript",
        "zig",
    },
    highlight = { enable = true },
}

-----------
--- LSP ---
-----------
-- pretty LSP diagnostics icons
for icon_name, icon in pairs { Error = " ", Warning = " ", Hint = " ", Information = " " } do
    local hl = "LspDiagnosticsSign" .. icon_name
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- enable completion capabilities for LSP
local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

function setup_lsp_common(client, bufnr)
    require 'illuminate'.on_attach(client)
    if client.server_capabilities.documentSymbolProvider then
        require 'nvim-navic'.attach(client, bufnr)
        vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end
end

require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- then setup your lsp server as usual
local lspconfig = require('lspconfig')


local lspconfig = require 'lspconfig'
for _, server in pairs { "clangd", "gopls", "hls", "pylsp", "tsserver", "verible" } do
    lspconfig[server].setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            if server ~= "clangd" and server ~= "verible" then
                require 'lsp-format'.on_attach(client)
            end
            setup_lsp_common(client, bufnr)
        end,
    }
end

require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- then setup your lsp server as usual
local lspconfig = require('lspconfig')

-- example to setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})

-- Rust
-- (this sets up rust-analyzer, so don't do it above)
require 'rust-tools'.setup {
    tools = {
        inlay_hints = {
            highlight = 'LineNr',
        },
    },
    server = {
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    features = 'all',
                },
            },
        },
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            require 'lsp-format'.on_attach(client)
            setup_lsp_common(client, bufnr)
        end,
    },
}
require 'crates'.setup()

-- LSP diagnostic lines
require 'lsp_lines'.setup()

local lines_enabled = true
function toggle_lines()
    lines_enabled = not lines_enabled
    vim.diagnostic.config { virtual_lines = lines_enabled, virtual_text = not lines_enabled }
end

wk.register { ['<leader>j'] = { toggle_lines, "Show diagnostic lines" } }
toggle_lines()

------------------------
--- cmp (completion) ---
------------------------
local cmp = require 'cmp'
cmp.setup {
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "vsnip" },
        { name = "crates" },
    }, {
        { name = "buffer" },
    }),
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<M-j>"] = cmp.mapping.select_next_item(),
        ["<M-k>"] = cmp.mapping.select_prev_item(),
        ["<M-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
    },
    formatting = {
        format = require 'lspkind'.cmp_format(),
    },
}

-----------
--- Git ---
-----------
require 'gitsigns'.setup {
    numhl = true,
    current_line_blame = true,
    on_attach = function(bufnr)
         wk.register({
                [']h'] = { ':Gitsigns next_hunk<CR>', "Next hunk" },
                ['[h'] = { ':Gitsigns prev_hunk<CR>', "Previous hunk" },
            })
        wk.register({
                g = {
                    b = { ':Gitsigns blame_line<CR>', "Blame line" },
                    d = { ':Gitsigns toggle_deleted<CR>', "Toggle deleted hunks" },
                    p = { ':Gitsigns preview_hunk<CR>', "Preview hunk" },
                    r = { ':Gitsigns reset_hunk<CR>', "Reset hunk" },
                    s = { ':Gitsigns stage_hunk<CR>', "Stage hunk" },
                    S = { ':Gitsigns undo_stage_hunk<CR>', "Undo stage hunk" },
                    v = { ':<C-U>Gitsigns select_hunk<CR>', "Select hunk" },
                },
            },
            { prefix = '<leader>' })
        -- TODO: fix leader/these mappings in visual mode
        wk.register({
                g = {
                    r = { ':Gitsigns reset_hunk<CR>', "Reset hunk" },
                    s = { ':Gitsigns stage_hunk<CR>', "Stage hunk" },
                },
            },
            {
                mode = 'v',
                prefix = '<leader>',
            })
    end
}

require 'git-conflict'.setup {
    default_mappings = true,
    disable_diagnostics = true,
    highlights = {
        incoming = "DiffText",
        current = "DiffAdd",
    },
}

---------------
--- Lualine ---
---------------
require 'lualine'.setup {
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "filename", { "diagnostics", sources = { "nvim_diagnostic" } } },
        lualine_x = { "filetype" },
        lualine_y = { "encoding", "fileformat" },
        lualine_z = { "progress", "location" },
    },
}

--------------
--- Notify ---
--------------
local notify = require 'notify'
notify.setup()

-- set the default notify handler to the notify plugin
vim.notify = function(msg, ...)
    -- ignore this message
    if msg:match "warning: multiple different client offset_encodings" then
        return
    end
    notify(msg, ...)
end

-- LSP messages as notifications
vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({
        "ERROR",
        "WARN",
        "INFO",
        "DEBUG",
    })[result.type]
    notify(result.message, lvl, {
        title = "LSP | " .. client.name,
        timeout = 10000,
        keep = function()
            return lvl == "ERROR" or lvl == "WARN"
        end,
    })
end

-------------
--- Hover ---
-------------
hover = require 'hover'
hover.setup {
    init = function()
        require 'hover.providers.lsp'
        require 'hover.providers.gh'
        require 'hover.providers.gh_user'
        require 'hover.providers.man'
        require 'hover.providers.dictionary'
    end,
}

wk.register({
        a = { vim.lsp.buf.code_action, "Code action" },
        F = { vim.lsp.buf.format, "Format current file" },
        h = { hover.hover, "Show symbol info" },
        H = { hover.hover_select, "Show symbol info (select)" },
        k = { vim.lsp.buf.signature_help, "Show signature" },
        r = { vim.lsp.buf.rename, "Rename symbol" },
        s = { telescope_builtin.lsp_document_symbols, "Find symbol" },
        S = { telescope_builtin.lsp_workspace_symbols, "Find workspace symbol" },
    },
    { prefix = '<leader>' })

wk.register({
        g = {
            c = { telescope_builtin.lsp_incoming_calls, "Caller" },
            C = { telescope_builtin.lsp_outgoing_calls, "Callee" },
            d = { telescope_builtin.lsp_definitions, "Definition" },
            D = { vim.lsp.buf.declaration, "Declaration" },
            t = { telescope_builtin.lsp_type_definitions, "Type definition" },
            r = { telescope_builtin.lsp_references, "Reference" },
            i = { telescope_builtin.lsp_implementations, "Implementation" },
            o = { ':ClangdSwitchSourceHeader<CR>', "Source/header" },
        },
    })

-------------
--- Other ---
-------------
require 'colorizer'.setup()
require 'range-highlight'.setup()
require 'todo-comments'.setup()
require 'dressing'.setup{
    input = {
        override = function(conf)
            conf.col = -1
            conf.row = 0
            return conf
        end,
    },
}
require 'transparent'.setup { enable = true }
require 'tidy'.setup()
require 'guess-indent'.setup()
