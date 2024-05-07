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
            require 'which-key'.setup {
                icons = {
                    separator = "->",
                },
                layout = {
                    align = 'center',
                },
            }
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
                    lualine_a = { 'mode', 'selectioncount' },
                    lualine_b = { 'diagnostics' },
                    lualine_c = { function()
                        if #vim.lsp.get_active_clients() > 0 then return require 'nvim-navic'.get_location() end
                        return ''
                    end },
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
                    border = 'single',
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
