-- UI

return {
    {
        'folke/which-key.nvim',
        config = function()
            require 'which-key'.setup {
                preset = 'modern',
                icons = {
                    separator = "➤ ",
                },
                delay = 400,
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
        'stevearc/dressing.nvim',
        config = function()
            require 'dressing'.setup {
                input = { border = 'single', },
                select = {
                    backend = { 'builtin' },
                    builtin = {
                        show_numbers = false,
                        border = 'single',
                        relative = 'win',
                        win_options = {
                            winhighlight = 'CursorLine:PmenuSel',
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
    {
        'rachartier/tiny-inline-diagnostic.nvim',
        opts = {
            signs = {
                left = " ",
                right = " ",
            },
        },
    },
    {
        'Bekaboo/dropbar.nvim',
        opts = {
            sources = {
                path = {
                    relative_to = function(_, _) return os.getenv 'HOME' end
                }
            }
        }
    },
    {
        "karb94/neoscroll.nvim",
        opts = {
            mappings = {},
        },
        keys = {
            { "<C-u>", function() require 'neoscroll'.ctrl_u({ duration = 100 }) end },
            { "<C-d>", function() require 'neoscroll'.ctrl_d({ duration = 100 }) end },
            { "<C-b>", function() require 'neoscroll'.ctrl_b({ duration = 200 }) end },
            { "<C-f>", function() require 'neoscroll'.ctrl_f({ duration = 200 }) end },
            { "<C-y>", function() require 'neoscroll'.scroll(-0.1, { move_cursor = false, duration = 20 }) end },
            { "<C-e>", function() require 'neoscroll'.scroll(0.1, { move_cursor = false, duration = 20 }) end },
            { "zt",    function() require 'neoscroll'.zt({ half_win_duration = 10 }) end },
            { "zz",    function() require 'neoscroll'.zz({ half_win_duration = 10 }) end },
            { "zb",    function() require 'neoscroll'.zb({ half_win_duration = 10 }) end },
        },
    },
}
