"""""""""""""""
""" Plugins """
"""""""""""""""
call plug#begin(stdpath('data') . 'plugged')
    " needed for other plugins
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'

    " picker UI
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-file-browser.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}
    Plug 'nvim-telescope/telescope-ui-select.nvim'
    Plug 'nvim-telescope/telescope-github.nvim'
    Plug 'cljoly/telescope-repo.nvim'
    Plug 'crispgm/telescope-heading.nvim'

    " syntax highlighting
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'

    " LSP utils
    Plug 'neovim/nvim-lspconfig'
    Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' " diagnostic lines
    Plug 'simrat39/rust-tools.nvim'
    Plug 'lukas-reineke/lsp-format.nvim' " auto format
    Plug 'SmiteshP/nvim-navic' " breadcrumbs

    " completion
    Plug 'onsails/lspkind-nvim'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-nvim-lua'
    Plug 'hrsh7th/nvim-cmp'

    " git
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'akinsho/git-conflict.nvim', { 'tag': 'v1.0.0' }

    " word/range highlighting
    Plug 'NvChad/nvim-colorizer.lua' " hex color highlighter
    Plug 'winston0410/cmd-parser.nvim' " required for range-highlight
    Plug 'winston0410/range-highlight.nvim' " highlights range entered in cmdline
    Plug 'folke/todo-comments.nvim' " higlight todo comments
    Plug 'RRethy/vim-illuminate' " highlight word under cursor

    " UI improvements
    Plug 'nvim-lualine/lualine.nvim' " statusline
    Plug 'kyazdani42/nvim-web-devicons' " statusline icons
    Plug 'folke/which-key.nvim' " show key mapping hints
    Plug 'stevearc/dressing.nvim' " better select/input menus
    Plug 'rcarriga/nvim-notify' " better notifications
    Plug 'lewis6991/hover.nvim' " better hover

    " theming
    Plug 'projekt0n/github-nvim-theme' " github colors
    Plug 'xiyaowong/nvim-transparent'

    " other
    Plug 'LnL7/vim-nix' " nix language support
    Plug 'Saecki/crates.nvim' " cargo file support
    Plug 'mcauley-penney/tidy.nvim' " trim whitespace
    Plug 'tpope/vim-eunuch' " unix commands in vim
    Plug 'mfussenegger/nvim-dap' " debugging
call plug#end()

""""""""""""""""""""""""
""" General settings """
""""""""""""""""""""""""
syntax on
set number " enable line numbers
set ignorecase " when searching
set smartcase " don't ignore case if search string contains uppercase letters
set nocompatible " disable vi compatibility
set incsearch " incremental searching
set visualbell " disable bleeping
set expandtab " insert spaces with tab
set tabstop=4 " width of tab
set shiftwidth=4 " width of indent
set ruler " cursor position in the status line
set cursorline " highlight line with cursor
set autoindent " apply indentation of the previous line
set smartindent " indent based on syntax
set nohlsearch " do not highlight all search matches
set virtualedit=all " allow virtual editing
set backspace=indent,eol,start " backspace anything in insert mode
set mouse=a " mouse support
set autochdir " change working dir to buffer dir
set completeopt=menuone,noselect " required for nvim-cmp
set timeoutlen=250 " mapping timeout (which-key shows up after it)
set hidden " switch between buffers without saving
set undofile " persistent undo
set nobackup " disable backup
set nowritebackup
set scrolloff=10 " keep cursor 10 lines from screen edge
set termguicolors " prevent warning about opacity changes

""""""""""""""""
""" Mappings """
""""""""""""""""
" TODO use which-key instead
let g:mapleader=';' " set leader key to ;

" recent files
nnoremap <Leader>m :Telescope oldfiles<CR>

" currently open buffers
nnoremap <Leader>b :lua require 'telescope.builtin'.buffers{ignore_current_buffer=true, sort_mru=true}<CR>

" find in current buffer
nnoremap <Leader>/ :Telescope current_buffer_fuzzy_find<CR>

" git browsing
nnoremap <Leader>gf :Telescope git_files<CR>
nnoremap <Leader>gc :Telescope git_bcommits<CR>
nnoremap <Leader>gC :Telescope git_commits<CR>
nnoremap <Leader>r :Telescope repo<CR>

" GitHub browsing
nnoremap <Leader>Ghi :Telescope gh issues<CR>
nnoremap <Leader>Ghp :Telescope gh pull_request<CR>
nnoremap <Leader>Ghx :Telescope gh gist<CR>
nnoremap <Leader>Gha :Telescope gh run<CR>

" browse headings
nnoremap gh :Telescope heading<CR>

" browse files
nnoremap <Leader>f :lua require 'telescope'.extensions.file_browser.file_browser { respect_gitignore = false }<CR>

" search files
nnoremap <Leader>s :lua require 'telescope.builtin'.find_files {hidden = true, follow = true}<CR>

" ripgrep current dir
nnoremap <Leader>d :Telescope live_grep<CR>

" paste register
nnoremap <Leader>p :Telescope registers<CR>

" paste register
nnoremap <Leader>l :Telescope diagnostics<CR>

" write file
nnoremap <Leader>w :w<CR>

" sudo write file
nnoremap <Leader>W :w !sudo tee %<CR>

" quit/force quit
nnoremap <Leader>q :qa<CR>
nnoremap <Leader>Q :qa!<CR>

" move up/down on visual lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" window managment with the alt key
nnoremap <M-q> <C-w>q
nnoremap <M-c> <C-w>s
nnoremap <M-v> <C-w>v
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l
nnoremap <M-S-h> <C-w><S-h>
nnoremap <M-S-j> <C-w><S-j>
nnoremap <M-S-k> <C-w><S-k>
nnoremap <M-S-l> <C-w><S-l>

" faster scrolling
noremap H <C-o>
noremap J <C-e><C-e>

" move through jump history
noremap K <C-y><C-y>
noremap L <C-i>

" make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

" LSP mappings
nnoremap <silent> gc    :Telescope lsp_incoming_calls<CR>
nnoremap <silent> gC    :Telescope lsp_outgoing_calls<CR>
nnoremap <silent> gd    :Telescope lsp_definitions<CR>
nnoremap <silent> gD    :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gt    :Telescope lsp_type_definitions<CR>
nnoremap <silent> gr    :Telescope lsp_references<CR>
nnoremap <silent> gi    :Telescope lsp_implementations<CR>
nnoremap <silent> gs    :Telescope lsp_document_symbols<CR>
nnoremap <silent> gS    :Telescope lsp_workspace_symbols<CR>
nnoremap <silent> mf    :lua vim.lsp.buf.format()<CR>
vnoremap <silent> mf    :lua vim.lsp.buf.format()<CR>
nnoremap <silent> mn    :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> ma    :lua vim.lsp.buf.code_action()<CR>
vnoremap <silent> ma    :lua vim.lsp.buf.range_code_action()<CR>
nnoremap <silent> go    :ClangdSwitchSourceHeader<CR>

"""""""""""""""""""
""" Line length """
"""""""""""""""""""

au BufRead,BufNewFile *.md setlocal textwidth=80

colorscheme github_dark " after lualine setup

lua <<EOF
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
local telescope = require 'telescope'
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

-- breadcrumbs in the winbar
vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

-- enable completion capabilities for LSP
local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

function setup_lsp_common(client, bufnr)
    require 'illuminate'.on_attach(client)
    if client.server_capabilities.documentSymbolProvider then
        require 'nvim-navic'.attach(client, bufnr)
    end
end

local lspconfig = require 'lspconfig'
for _, server in pairs { "clangd", "gopls", "hls", "pylsp", "tsserver" } do
	lspconfig[server].setup {
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			if server ~= "clangd" then
				require 'lsp-format'.on_attach(client)
			end
            setup_lsp_common(client, bufnr)
		end,
	}
end

-- Rust
-- (this sets up rust-analyzer, so don't do it above)
require 'rust-tools'.setup {
	server = {
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			require 'lsp-format'.on_attach(client)
            setup_lsp_common(client, bufnr)
		end,
	},
}
require 'crates'.setup()

-- show diagnostic in a popup
wk.register { ['<leader>e'] = { vim.diagnostic.open_float, "Show diagnostic" } }

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
                g = {
                    b = { ':Gitsigns blame_line<CR>', "Blame line" },
                    d = { ':Gitsigns toggle_deleted<CR>', "Toggle deleted hunks" },
                    h = { ':Gitsigns next_hunk<CR>', "Next hunk" },
                    H = { ':Gitsigns prev_hunk<CR>', "Previous hunk" },
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
wk.register { m = { h = { hover.hover, "Hover" }, H = { hover.hover_select, "Hover (select)" } } }

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
EOF
