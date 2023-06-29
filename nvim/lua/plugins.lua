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

            local telescope_builtin = require 'telescope.builtin'

            require 'which-key'.register({
                    ['/'] = { telescope_builtin.current_buffer_fuzzy_find, 'Find in current file' },
                    ['?'] = { telescope_builtin.live_grep, 'Find in files' },
                    b = { function() telescope_builtin.buffers { ignore_current_buffer = true, sort_mru = true } end,
                        'Buffers' },
                    f = {
                        name = 'File',
                        F = { function() telescope_builtin.find_files { hidden = true, follow = true } end, 'Find file' },
                        r = { telescope_builtin.oldfiles, 'Recent files' },
                    },
                    p = { telescope_builtin.registers, 'Paste' },
                    [';'] = { telescope_builtin.resume, 'Last picker' },
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
                        name = 'File',
                        f = {
                            function() telescope.extensions.file_browser.file_browser { respect_gitignore = false } end,
                            'Browse files' },
                    },
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
        'nvim-telescope/telescope-ui-select.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function()
            require 'telescope'.load_extension 'ui-select'
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
        'crispgm/telescope-heading.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim', 'folke/which-key.nvim' },
        config = function()
            require 'telescope'.load_extension 'heading'
            require 'which-key'.register {
                g = {
                    h = { 'Telescope heading', 'Heading' },
                },
            }
        end,
    },
    -- syntax highlighting and awareness
    { import = 'plugins-ts' },
    { import = 'plugins-lsp' },
    { 'Saecki/crates.nvim',  opts = {} }, -- cargo file support
    { import = 'plugins-cmp' },
    { import = 'plugins-git' },
    {
        'NvChad/nvim-colorizer.lua', -- hex color highlighter
        opts = {},
    },
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
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = { 'filename', { 'diagnostics', sources = { 'nvim_diagnostic' } } },
                    lualine_x = { 'filetype' },
                    lualine_y = { 'encoding', 'fileformat' },
                    lualine_z = { 'progress', 'location' },
                },
            }
        end,
    },
    {
        'kyazdani42/nvim-web-devicons',
        opts = {}
    },                            -- statusline icons
    {
        'stevearc/dressing.nvim', -- better select/input menus
        opts = {
            input = {
                override = function(conf)
                    conf.col = -1
                    conf.row = 0
                    return conf
                end,
            },
        },
    },
    {
        'rcarriga/nvim-notify', -- better notifications
        config = function()
            local notify = require 'notify'
            notify.setup { background_colour = '#00000000', }

            -- set the default notify handler to the notify plugin
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.notify = function(msg, ...)
                -- ignore this message
                if msg:match 'warning: multiple different client offset_encodings' then
                    return
                end
                notify(msg, ...)
            end

            -- LSP messages as notifications
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                local lvl = ({
                    'ERROR',
                    'WARN',
                    'INFO',
                    'DEBUG',
                })[result.type]
                notify(result.message, lvl, {
                    title = 'LSP | ' .. client.name,
                    timeout = 120,
                    keep = function()
                        return lvl == 'ERROR' or lvl == 'WARN'
                    end,
                })
            end
        end,
    },
    -- theming
    {
        'projekt0n/github-nvim-theme',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd [[colorscheme github_light]]
        end,
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
        'zbirenbaum/neodim',
        opts = {}
    },
    {
        'sunjon/Shade.nvim',
        opts = {
            overlay_opacity = 80,
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
            peek.setup { theme = 'light' }
            require 'which-key'.register({
                    n = {
                        name = 'Notes',
                        p = {
                            function()
                                if peek.is_open() then
                                    peek.close()
                                else
                                    peek.open()
                                end
                            end,
                            'Preview' },
                    },
                },
                { prefix = '<leader>' })
        end,
    },
    {
        'folke/edgy.nvim',
        event = 'VimEnter',
        init = function()
            vim.opt.laststatus = 3
            vim.opt.splitkeep = 'screen'
        end,
        config = function()
            require 'edgy'.setup {
                animate = { enabled = false },
                exit_when_last = true,
                bottom = {

                    {
                        title = 'Docs',
                        ft = 'nvim-docs-view',
                        pinned = true,
                        open = 'DocsViewToggle',
                    },
                    {
                        title = 'Outline',
                        ft = 'Outline',
                        pinned = true,
                        open = 'SymbolsOutlineOpen',
                    },
                },
            }
            local symbols_outline = require 'symbols-outline'
            require 'which-key'.register({
                    t = { function()
                        vim.cmd [[DocsViewToggle]]
                        symbols_outline.toggle_outline()
                    end, 'Symbol tree' }
                },
                { prefix = '<leader>' })
        end,
        dependencies = {
            { 'amrbashir/nvim-docs-view', opts = {} },
            {
                'simrat39/symbols-outline.nvim',
                config = function()
                    local symbols_outline = require 'symbols-outline'
                    symbols_outline.setup()
                    require 'which-key'.register({
                            t = { symbols_outline.toggle_outline, 'Symbol tree' }
                        },
                        { prefix = '<leader>' })
                end
            },
            'folke/which-key.nvim',
        },
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
            -- venn.nvim: enable or disable keymappings
            function _G.Toggle_venn()
                local venn_enabled = vim.inspect(vim.b.venn_enabled)
                if venn_enabled == "nil" then
                    vim.b.venn_enabled = true
                    vim.cmd [[setlocal ve=all]]
                    -- draw a line on HJKL keystokes
                    vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
                    vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
                    vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
                    vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
                    -- draw a box by pressing "f" with visual selection
                    vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
                else
                    vim.cmd [[setlocal ve=]]
                    vim.cmd [[mapclear <buffer>]]
                    vim.b.venn_enabled = nil
                end
            end

            -- toggle keymappings for venn using <leader>v
            vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true })
        end,
    },
}
