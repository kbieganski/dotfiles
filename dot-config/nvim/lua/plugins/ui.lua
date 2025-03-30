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
                show_help = false,
                win = { border = 'single' },
                icons = { separator = '->', mappings = false },
                delay = 400,
            }
        end,
    },
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        opts = {
            notifier = {
                enabled = true,
                style = 'minimal',
                top_down = false,
                margin = { top = 1, bottom = 1 },
            },
            picker = {
                enabled = false,
                prompt = '',
                layout = {
                    layout = {
                        box = 'horizontal',
                        min_width = 120,
                        width = 0.5,
                        height = 0.5,
                        border = 'single',
                        {
                            box = 'vertical',
                            { win = 'list', },
                            { win = 'input', height = 1, border = 'top' },
                        },
                        { win = 'preview', title = '{preview}', border = 'left', width = 0.5 },
                    }
                },
                previewers = {
                    diff = { builtin = false, cmd = { 'delta', '--file-style=omit' }, },
                },
                win = {
                    input = {
                        keys = {
                            ['<Esc>'] = { 'cancel', mode = { 'n', 'i' } },
                        },
                    },
                }
            },
            scroll = {
                enabled = true,
                animate = { duration = { step = 10, total = 200 }, },
                animate_repeat = { delay = 100, duration = { step = 2, total = 40 }, },
            },
        },
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
        config = function()
            local path = {
                get_symbols = function(buf, _, _)
                    local fname = vim.api.nvim_buf_get_name(buf)
                    local name = fname
                    local home = os.getenv 'HOME'
                    if name:sub(1, #home) == home then
                        name = '~/' .. name:sub(#home + 2)
                    end
                    local hl = 'StatusLine'
                    if vim.bo[buf].modified then
                        hl = 'DiagnosticInfo'
                        name = name .. '  '
                    end
                    return {
                        require 'dropbar.bar'.dropbar_symbol_t:new({
                            icon = '󰈔 ',
                            icon_hl = hl,
                            name = name,
                            name_hl = hl,
                            fname = fname,
                            on_click = function(self) Lf(self.fname) end,
                        }),
                    }
                end,
            }
            require 'dropbar'.setup {
                bar = {
                    enable = function(buf, win)
                        if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
                            return false
                        end
                        local bufname = vim.api.nvim_buf_get_name(buf)
                        return bufname:sub(1, 5) ~= '/tmp/' and vim.uv.fs_stat(bufname)
                            and vim.bo[buf].ft ~= 'help' and vim.bo[buf].buflisted
                    end,
                    sources = function(buf, _)
                        local sources = require 'dropbar.sources'
                        local utils = require 'dropbar.utils'
                        if vim.bo[buf].ft == 'markdown' then
                            return {
                                path,
                                sources.markdown,
                            }
                        end
                        if vim.bo[buf].buftype == 'terminal' then
                            return {
                                path,
                                sources.terminal,
                            }
                        end
                        return {
                            path,
                            utils.source.fallback({
                                sources.lsp,
                                sources.treesitter,
                            }),
                        }
                    end,
                },
                menu = {
                    win_configs = { border = 'single' }
                },
            }
            vim.ui.select = require 'dropbar.utils.menu'.select
            vim.keymap.set('n', '<leader><space>', require 'dropbar.api'.pick, { desc = 'Pick breadcrumb' })
        end
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
    },
}
