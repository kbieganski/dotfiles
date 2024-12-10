-- Completion

return {
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        enabled = function() return not vim.lsp.completion end,
        dependencies = {
            'onsails/lspkind-nvim',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-cmdline',
            {
                'zbirenbaum/copilot-cmp',
                dependencies = {
                    {
                        'zbirenbaum/copilot.lua',
                        cmd = 'Copilot',
                        build = ':Copilot auth',
                        config = function()
                            require 'copilot'.setup {
                                -- as recommended by copilot_cmp readme, disable these:
                                suggestion = { enabled = false },
                                panel = { enabled = false },
                            }
                        end,
                    },
                },
                opts = {}
            },
        },
        config = function()
            local cmp = require 'cmp'
            local lsp_cmp_format = require 'lspkind'.cmp_format { mode = 'symbol', maxwidth = 20 }
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
            end
            cmp.setup {
                preselect = cmp.PreselectMode.None, -- Otherwise doesn't work well with Copilot
                sources = cmp.config.sources({
                    { name = 'nvim_lsp_signature_help' },
                    {
                        name = 'nvim_lsp',
                        entry_filter = function(entry, _)
                            return cmp.lsp.CompletionItemKind.Snippet ~= entry:get_kind()
                        end,
                    },
                    { name = 'nvim_lua' },
                    { name = 'copilot' },
                }, {
                    { name = 'path' },
                    { name = 'buffer' },
                    { name = 'crates' },
                }),
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                formatting = {
                    format =
                        function(entry, item)
                            if item.menu then
                                local menu_width = 40
                                local menu = vim.fn.strcharpart(item.menu, 0, menu_width - 1)
                                if #menu < #item.menu then
                                    item.menu = menu .. '…'
                                end
                                if #item.menu < menu_width then
                                    item.menu = item.menu .. (' '):rep(menu_width - #menu - 1)
                                end
                            end
                            if item.kind == 'Copilot' then
                                item.kind = ''
                                return item
                            end
                            return lsp_cmp_format(entry, item)
                        end
                },
                view = {
                    entries = { name = 'custom', selection_order = 'near_cursor' },
                },
                window = {
                    documentation = {
                        border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
                        winhighlight = '',
                    },
                },
                experimental = { ghost_text = true },
            }

            cmp.setup.cmdline({ '/', '?' }, {
                preselect = cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.cmdline {
                    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                },
                sources = {
                    { name = 'buffer' }
                },
            })

            cmp.setup.cmdline(':', {
                preselect = cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.cmdline {
                    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                },
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                }, {
                    { name = 'buffer' }
                })
            })
        end,
    }
}
