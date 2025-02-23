-- UI

return {
    {
        'kbieganski/austere-theme.nvim',
        config = function()
            vim.cmd.colorscheme 'austere-theme'
        end
    },
    {
        'folke/which-key.nvim',
        config = function()
            require 'which-key'.setup {
                preset = 'modern',
                icons = { separator = '->', mappings = false },
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
        'rachartier/tiny-inline-diagnostic.nvim',
        opts = {
            preset = 'simple',
            options = {
                use_icons_from_diagnostic = true,
                enable_on_insert = true,
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
                    return bufname:sub(1, 5) ~= '/tmp/' and vim.uv.fs_stat(bufname)
                        and vim.bo[buf].ft ~= 'help' and vim.bo[buf].buflisted
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
        'yorickpeterse/nvim-pqf',
        opts = {
            signs = {
                error = { text = vim.diagnostic.config().signs.text[vim.diagnostic.severity.ERROR] },
                warning = { text = vim.diagnostic.config().signs.text[vim.diagnostic.severity.WARN] },
                info = { text = vim.diagnostic.config().signs.text[vim.diagnostic.severity.INFO] },
                hint = { text = vim.diagnostic.config().signs.text[vim.diagnostic.severity.HINT] },
            },
        }
    }
}
