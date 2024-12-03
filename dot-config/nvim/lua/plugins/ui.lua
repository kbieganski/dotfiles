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
            preset = 'simple',
            options = {
                use_icons_from_diagnostic = true,
            },
        },
    },
    {
        'Bekaboo/dropbar.nvim',
        opts = {
            bar = {
                enable = function(buf, win)
                    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
                        return false
                    end
                    local bufname = vim.api.nvim_buf_get_name(buf)
                    return vim.uv.fs_stat(bufname) and vim.bo[buf].ft ~= 'help'
                end
            },
            sources = {
                path = {
                    modified = function(sym)
                        return sym:merge({
                            name = sym.name .. '  ',
                            name_hl = 'DiagnosticInfo',
                            icon_hl = 'DiagnosticInfo',
                        })
                    end,
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
            { "<C-u>", function() require 'neoscroll'.ctrl_u({ duration = 20 }) end,                            mode = { 'n', 'v' } },
            { "<C-d>", function() require 'neoscroll'.ctrl_d({ duration = 20 }) end,                            mode = { 'n', 'v' } },
            { "<C-b>", function() require 'neoscroll'.ctrl_b({ duration = 50 }) end,                            mode = { 'n', 'v' } },
            { "<C-f>", function() require 'neoscroll'.ctrl_f({ duration = 50 }) end,                            mode = { 'n', 'v' } },
            { "<C-y>", function() require 'neoscroll'.scroll(-0.1, { move_cursor = false, duration = 10 }) end, mode = { 'n', 'v' } },
            { "<C-e>", function() require 'neoscroll'.scroll(0.1, { move_cursor = false, duration = 10 }) end,  mode = { 'n', 'v' } },
            { "zt",    function() require 'neoscroll'.zt({ half_win_duration = 10 }) end,                       mode = { 'n', 'v' } },
            { "zz",    function() require 'neoscroll'.zz({ half_win_duration = 10 }) end,                       mode = { 'n', 'v' } },
            { "zb",    function() require 'neoscroll'.zb({ half_win_duration = 10 }) end,                       mode = { 'n', 'v' } },
        },
    },
    {
        'yorickpeterse/nvim-pqf',
        opts = {
            signs = {
                error = { text = vim.diagnostic.config().signs.text[vim.diagnostic.severity.ERROR], hl = 'DiagnosticSignError' },
                warning = { text = vim.diagnostic.config().signs.text[vim.diagnostic.severity.WARN], hl = 'DiagnosticSignWarn' },
                info = { text = vim.diagnostic.config().signs.text[vim.diagnostic.severity.INFO], hl = 'DiagnosticSignInfo' },
                hint = { text = vim.diagnostic.config().signs.text[vim.diagnostic.severity.HINT], hl = 'DiagnosticSignHint' },
            },
        }
    }
}
