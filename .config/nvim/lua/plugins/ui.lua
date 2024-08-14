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
                preset = 'helix',
                icons = {
                    separator = "➤ ",
                },
                delay = 500,
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
                sections = {
                    lualine_a = { 'mode', 'selectioncount' },
                    lualine_b = {},
                    lualine_c = { 'branch',
                        { 'filename', path = 3, symbols = { modified = '❬*❭', readonly = '❬ro❭', unnamed = '❬no name❭', new = '❬new❭' } },
                        function()
                            if #vim.lsp.get_active_clients() > 0 then return require 'nvim-navic'.get_location() end
                            return ''
                        end
                    },
                    lualine_x = {},
                    lualine_y = { 'diagnostics', 'diff' },
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
                input = { border = 'single', },
                select = {
                    backend = { 'builtin' },
                    builtin = { border = 'single' },
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
