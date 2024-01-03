-- Plugins

local function get_visual_selection()
    if vim.api.nvim_get_mode().mode ~= 'v' then
        return ''
    else
        local _, ls, cs = unpack(vim.fn.getpos('v'))
        local _, le, ce = unpack(vim.fn.getpos('.'))
        ls = ls - 1; le = le - 1; cs = cs - 1; ce = ce - 1
        local lines = vim.api.nvim_buf_get_text(0, math.min(ls, le), math.min(cs, ce), math.max(ls, le), math.max(cs, ce),
            {})
        return table.concat(lines, ' ')
    end
end

return {
    {
        'folke/which-key.nvim',
        config = function()
            local wk = require 'which-key'
            wk.setup {
                window = {
                    border = 'single',
                    margin = { 4, 4, 4, 4 },
                    padding = { 1, 1, 1, 1 },
                },
                layout = {
                    align = 'center',
                },
            }
            wk.register({
                    b = { 'Buffers' },
                    g = { 'Git' },
                    G = { 'GitHub' },
                    n = { 'Notes' },
                },
                { prefix = '<leader>' })
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
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
        end,
        keys = {
            { '<leader>`', function() require 'telescope.builtin'.marks() end, desc = 'Marks' },
            {
                '<leader>/',
                function()
                    local selection = get_visual_selection()
                    require 'telescope.builtin'.current_buffer_fuzzy_find({ default_text = selection })
                end,
                mode = { 'n', 'v' },
                desc = 'Find in current file'
            },
            {
                '<leader>?',
                function()
                    local selection = get_visual_selection()
                    require 'telescope.builtin'.live_grep({ default_text = selection })
                end,
                mode = { 'n', 'v' },
                desc = 'Find in files'
            },
            {
                '<leader>bb',
                function() require 'telescope.builtin'.buffers { ignore_current_buffer = true, sort_mru = true } end,
                desc = 'Switch buffer'
            },
            { '<leader>h', function() require 'telescope.builtin'.help_tags() end, desc = 'Help' },
            { '<leader>j', function() require 'telescope.builtin'.jumplist() end,  desc = 'Browse jumps' },
            { '<leader>l', function() require 'telescope.builtin'.resume() end,    desc = 'Last picker' },
            { '<leader>p', function() require 'telescope.builtin'.registers() end, desc = 'Paste' },
            { '<leader>r', function() require 'telescope.builtin'.oldfiles() end,  desc = 'Recent files' },
            {
                '<leader>s',
                function() require 'telescope.builtin'.find_files { hidden = true, follow = true } end,
                desc = 'Find file'
            },
        },
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
        config = function()
            require 'telescope'.load_extension 'file_browser'
        end,
        keys = {
            {
                '<leader>f',
                function() require 'telescope'.extensions.file_browser.file_browser { respect_gitignore = false } end,
                desc = 'Browse files'
            },
        },
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
        keys = {
            { '<leader>Ga', function() require 'telescope'.extensions.gh.run() end,          desc = 'Action runs' },
            { '<leader>Gg', function() require 'telescope'.extensions.gh.gist() end,         desc = 'Gist' },
            { '<leader>Gi', function() require 'telescope'.extensions.gh.issues() end,       desc = 'Issues' },
            { '<leader>Gp', function() require 'telescope'.extensions.gh.pull_request() end, desc = 'Pull requests' },
        },
    },
    {
        'cljoly/telescope-repo.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
        config = function()
            require 'telescope'.load_extension 'repo'
        end,
        keys = {
            { '<leader>gg', function() require 'telescope'.extensions.repo.repo() end, desc = 'Repositories' },
        },
    },
    {
        'debugloop/telescope-undo.nvim',
        dependencies = { -- note how they're inverted to above example
            {
                'nvim-telescope/telescope.nvim',
                dependencies = { 'nvim-lua/plenary.nvim' },
            },
        },
        keys = {
            {
                '<leader>u',
                function() require 'telescope'.extensions.undo.list() end,
                desc = 'undo history',
            },
        },
        opts = {},
        config = function()
            require 'telescope'.load_extension('undo')
        end,
    },
    -- syntax highlighting and awareness
    { import = 'plugins-ts' },
    { import = 'plugins-lsp' },
    { 'Saecki/crates.nvim',  ft = 'toml', opts = {} }, -- cargo file support
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
                    lualine_y = { 'encoding', 'fileformat', },
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
        config = function()
            vim.cmd [[colorscheme rose-pine-moon]]
        end,
    },
    {
        'levouh/tint.nvim',
        event = 'WinEnter',
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
        build = 'deno task --quiet build:fast',
        config = function()
            require 'peek'.setup { theme = 'dark' }
        end,
        keys = {
            {
                '<leader>v',
                function()
                    local peek = require 'peek'
                    if peek.is_open() then
                        peek.close()
                    else
                        vim.fn.system('i3-msg split horizontal')
                        peek.open()
                    end
                end,
                desc = 'Preview'
            },
        },
    },
    {
        'numToStr/Navigator.nvim',
        config = function()
            require 'Navigator'.setup {}
        end,
    },
    {
        'chentoast/marks.nvim',
        opts = {},
    },
    {
        'jbyuki/venn.nvim',
        config = function()
            function _G.toggle_venn()
                if not vim.b.venn_enabled then
                    vim.b.venn_enabled = true
                    vim.cmd [[setlocal ve=all]]
                    vim.keymap.set('n', 'J', '<C-v>j:VBox<CR>', { buffer = true, silent = true })
                    vim.keymap.set('n', 'K', '<C-v>k:VBox<CR>', { buffer = true, silent = true })
                    vim.keymap.set('n', 'H', '<C-v>h:VBox<CR>', { buffer = true, silent = true })
                    vim.keymap.set('n', 'L', '<C-v>l:VBox<CR>', { buffer = true, silent = true })
                    vim.keymap.set('v', 'f', ':VBox<CR>', { buffer = true, silent = true })
                else
                    vim.b.venn_enabled = false
                    vim.cmd [[setlocal ve=]]
                    vim.keymap.del('n', 'J', { buffer = true })
                    vim.keymap.del('n', 'K', { buffer = true })
                    vim.keymap.del('n', 'H', { buffer = true })
                    vim.keymap.del('n', 'L', { buffer = true })
                    vim.keymap.del('v', 'f', { buffer = true })
                end
            end
        end,
        keys = {
            { '<leader>d', ':lua toggle_venn()<CR>', desc = 'Toggle diagram drawing', silent = true },
        },
    },
}
