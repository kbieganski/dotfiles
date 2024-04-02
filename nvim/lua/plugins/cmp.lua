-- Completion

return {
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'neovim/nvim-lspconfig',
            'onsails/lspkind-nvim',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-cmdline',
            'f3fora/cmp-spell',
            'dcampos/nvim-snippy',
            {
                'zbirenbaum/copilot.lua',
                cmd = "Copilot",
                build = ":Copilot auth",
                config = function()
                    require 'copilot'.setup {
                        -- as recommended by copilot_cmp readme, disable these:
                        suggestion = { enabled = false },
                        panel = { enabled = false },
                    }
                end,
            },
            { 'zbirenbaum/copilot-cmp', opts = {} },
        },
        config = function()
            local cmp = require 'cmp'
            local snippy = require 'snippy'
            local lsp_cmp_format = require 'lspkind'.cmp_format { mode = 'symbol', maxwidth = 20 }
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            cmp.setup {

                preselect = cmp.PreselectMode.None,
                sources = cmp.config.sources({
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'copilot' },
                    {
                        name = 'spell',
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end,
                        },
                    },
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
                        elseif snippy.can_expand_or_advance() then
                            snippy.expand_or_advance()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif snippy.can_jump(-1) then
                            snippy.previous()
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
                snippet = {
                    expand = function(args)
                        snippy.expand_snippet(args.body)
                    end,
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
