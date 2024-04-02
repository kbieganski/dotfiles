-- UI

return {
    {
        dir = vim.fn.stdpath('config') .. '/dev/diagline-popup',
        opts = {},
    },
    {
        dir = vim.fn.stdpath('config') .. '/dev/lucid',
        config = function()
            vim.cmd.colorscheme 'lucid'
        end,
    },
    {
        'folke/which-key.nvim',
        config = function()
            local wk = require 'which-key'
            wk.setup {
                icons = {
                    separator = "->",
                },
                window = {
                    border = 'single',
                    margin = { 4, 4, 4, 4 },
                    padding = { 1, 1, 1, 1 },
                },
                layout = {
                    align = 'center',
                },
            }
            vim.keymap.set('n', '=', function() wk.show('=') end)
        end,
    },
    {
        'winston0410/range-highlight.nvim',
        opts = {},
        dependencies = {
            {
                'winston0410/cmd-parser.nvim',
                opts = {},
            },
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            local searchcount = function()
                local sc = vim.fn.searchcount()
                return sc.current .. '/' .. sc.total
            end
            require 'lualine'.setup {
                options = {
                    disabled_filetypes = {
                        statusline = { 'Outline', 'dapui_watches', 'dapui_stacks', 'dapui_breakpoints', 'dapui_scopes',
                            'dapui_console', 'dap-repl' },
                    },
                },
                sections = {
                    lualine_a = { 'mode', function() if vim.b.venn_enabled then return 'D' else return '' end end, 'selectioncount' },
                    lualine_b = { 'diagnostics' },
                    lualine_c = { function() return require 'nvim-navic'.get_location() end },
                    lualine_x = { 'diff' },
                    lualine_y = { 'branch', 'filename' },
                    lualine_z = { searchcount, 'progress', 'location' },
                },
                inactive_sections = {
                    lualine_a = { 'mode' },
                    lualine_c = {},
                    lualine_b = {},
                    lualine_x = {},
                    lualine_y = { 'filename' },
                    lualine_z = { searchcount, 'progress', 'location' },
                },
            }
        end,
    },
    'kyazdani42/nvim-web-devicons',
    {
        'stevearc/dressing.nvim',
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
        'j-hui/fidget.nvim',
        opts = {
            notification = {
                override_vim_notify = true,
                window = {
                    winblend = 0,
                },
            },
        },
    },
}
