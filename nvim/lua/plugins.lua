-- Plugins
return {
    {
        'folke/which-key.nvim',
        config = function()
            local wk = require 'which-key'
            wk.setup {
                plugins = { spelling = true },
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
                    bx = { ':bn<CR>:bd#<CR>', 'Close buffer' },
                    bX = { ':bn<CR>:bd#!<CR>', 'Force close buffer' },
                },
                { prefix = '<leader>' })
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'folke/which-key.nvim',
        },
        config = function()
            local telescope = require 'telescope'
            telescope.setup {
                defaults = {
                    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    layout_strategy = 'flex',
                    layout_config = {
                        flex = { flip_columns = 240 },
                        vertical = { width = 0.9, height = 0.9 },
                        horizontal = { width = 0.9, height = 0.9 },
                    },
                    mappings = {
                        i = {
                            ['<ESC>'] = 'close',
                            ['<M-j>'] = 'move_selection_next',
                            ['<M-k>'] = 'move_selection_previous',
                        },
                    },
                    file_ignore_patterns = { '.cache', '.clangd' },
                },
                extensions = {
                    hijack_netrw = true,
                },
            }

            local tscp_builtin = require 'telescope.builtin'

            require 'which-key'.register({
                    ['/'] = { tscp_builtin.current_buffer_fuzzy_find, 'Find in current file' },
                    ['?'] = { tscp_builtin.live_grep, 'Find in files' },
                    b = { 'Buffers' },
                    b = { function() tscp_builtin.buffers { ignore_current_buffer = true, sort_mru = true } end, 'Switch buffer' },
                    h = { tscp_builtin.help_tags, 'Help' },
                    j = { tscp_builtin.jumplist, 'Browse jumps' },
                    l = { tscp_builtin.resume, 'Last picker' },
                    p = { tscp_builtin.registers, 'Paste' },
                    r = { tscp_builtin.oldfiles, 'Recent files' },
                    s = { function() tscp_builtin.find_files { hidden = true, follow = true } end, 'Find file' },
                },
                { prefix = '<leader>' })
        end
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim', 'folke/which-key.nvim' },
        config = function()
            local telescope = require 'telescope'
            telescope.load_extension 'file_browser'
            require 'which-key'.register({
                    f = {
                        function() telescope.extensions.file_browser.file_browser { respect_gitignore = false } end,
                        'Browse files' },
                },
                { prefix = '<leader>' })
        end
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',

        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function()
            require 'telescope'.load_extension 'fzf'
        end,
    },
    {
        'nvim-telescope/telescope-github.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
        config = function()
            require 'telescope'.load_extension 'gh'
        end,
    },
    {
        'cljoly/telescope-repo.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim', 'folke/which-key.nvim' },
        config = function()
            local telescope = require 'telescope'
            telescope.load_extension 'repo'
            require 'which-key'.register({
                    g = {
                        name = 'Git',
                        g = { telescope.extensions.repo.repo, 'Repositories' },
                    },
                },
                { prefix = '<leader>' })
        end,
    },
    {
        "debugloop/telescope-undo.nvim",
        dependencies = { -- note how they're inverted to above example
            {
                "nvim-telescope/telescope.nvim",
                dependencies = { "nvim-lua/plenary.nvim" },
            },
        },
        keys = {
            { -- lazy style key map
                "<leader>u",
                "<cmd>Telescope undo<cr>",
                desc = "undo history",
            },
        },
        opts = {
            -- don't use `defaults = { }` here, do this in the main telescope spec
            extensions = {
                undo = {
                    -- telescope-undo.nvim config, see below
                },
                -- no other extensions here, they can have their own spec too
            },
        },
        config = function(_, opts)
            -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
            -- configs for us. We won't use data, as everything is in it's own namespace (telescope
            -- defaults, as well as each extension).
            require("telescope").setup(opts)
            require("telescope").load_extension("undo")
        end,
    },
    -- syntax highlighting and awareness
    { import = 'plugins-ts' },
    { import = 'plugins-lsp' },
    { 'Saecki/crates.nvim',  opts = {} }, -- cargo file support
    { import = 'plugins-cmp' },
    { import = 'plugins-git' },
    {
        'winston0410/range-highlight.nvim', -- highlights range entered in cmdline
        opts = {},
        dependencies = {
            {
                'winston0410/cmd-parser.nvim', -- required for range-highlight
                opts = {},
            },
        },
    },
    {
        'folke/todo-comments.nvim', -- higlight todo comments
        opts = {},
    },
    -- UI improvements
    {
        'nvim-lualine/lualine.nvim', -- statusline
        config = function()
            require 'lualine'.setup {
                options = {
                    disabled_filetypes = {
                        statusline = { 'Outline', 'dapui_watches', 'dapui_stacks', 'dapui_breakpoints', 'dapui_scopes',
                            'dapui_console', 'dap-repl' },
                    },
                },
                sections = {
                    lualine_a = { 'mode', function() if vim.b.venn_enabled then return '[Diagram]' else return '' end end },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = { 'filename', { 'diagnostics', sources = { 'nvim_diagnostic' } } },
                    lualine_x = { 'filetype' },
                    lualine_y = { 'encoding', 'fileformat',  },
                    lualine_z = { 'progress', 'location' },
                },
            }
        end,
    },
    {
        'kyazdani42/nvim-web-devicons',
        opts = {}
    },
    {
        'stevearc/dressing.nvim', -- better select/input menus
        config = function()
            require 'dressing'.setup {
                input = {
                    override = function(conf)
                        conf.col = -1
                        conf.row = 0
                        return conf
                    end,
                },
                select = {
                    telescope = require('telescope.themes').get_cursor {
                        borderchars = {
                            { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                            prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
                            results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
                            preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                        },
                    },
                },
            }
        end,
        dependencies = { 'nvim-telescope/telescope.nvim' },
    },
    {
        -- 'vigoux/notifier.nvim',  -- this is the upstream, without level-aware content highlighting
        'williamboman/notifier.nvim',
        branch = 'feat/level-aware-content-highlighting',
        opts = {
            notify = {
                clear_time = 2000,
            },
        },
    },
    {
        'rose-pine/neovim',
        lazy = false,
        priority = 1001,
        config = function()
            vim.cmd [[colorscheme rose-pine-moon]]
        end,
    },
    {
        'levouh/tint.nvim',
        opts = {
            tint = -10,
            saturation = 0.9,
        },
    },
    { import = 'plugins-dap' },
    'LnL7/vim-nix',                 -- nix language support
    {
        'lewis6991/spaceless.nvim', -- trim whitespace
        opts = {},
    },
    {
        'NMAC427/guess-indent.nvim', -- guess indentation from file
        opts = {},
    },
    {
        'toppair/peek.nvim',
        dependencies = { 'which-key.nvim', },
        build = 'deno task --quiet build:fast',
        config = function()
            local peek = require 'peek'
            peek.setup { theme = 'dark' }
            require 'which-key'.register({
                    v = {
                        function()
                            if peek.is_open() then
                                peek.close()
                            else
                                vim.fn.system('i3-msg split horizontal')
                                peek.open()
                            end
                        end,
                        'Preview' },
                },
                { prefix = '<leader>' })
        end,
    },
    {
        'numToStr/Navigator.nvim',
        config = function()
            require 'Navigator'.setup {}
        end,
    },
    {
        'jbyuki/venn.nvim',
        config = function()
            vim.b.venn_enabled = false
            function _G.toggle_venn()
                if not vim.b.venn_enabled then
                    vim.b.venn_enabled = true
                    vim.cmd [[setlocal ve=all]]
                    vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true, silent = true })
                else
                    vim.cmd [[setlocal ve=]]
                    vim.api.nvim_buf_del_keymap(0, "n", "H")
                    vim.api.nvim_buf_del_keymap(0, "n", "J")
                    vim.api.nvim_buf_del_keymap(0, "n", "K")
                    vim.api.nvim_buf_del_keymap(0, "n", "L")
                    vim.api.nvim_buf_del_keymap(0, "v", "f")
                    vim.b.venn_enabled = false
                end
            end
        end,
        keys = {
            { '<leader>d', ':lua toggle_venn()<CR>', desc = 'Toggle diagram drawing' },
        },
    },
}
