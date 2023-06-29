return {
    {
        'hrsh7th/nvim-cmp',
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
            {
                "L3MON4D3/LuaSnip",
                version = "1.*",
                build = "make install_jsregexp"
            },
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
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
            local luasnip = require 'luasnip'
            require 'luasnip.loaders.from_vscode'.lazy_load()
            local lsp_cmp_format = require 'lspkind'.cmp_format { mode = 'symbol' }
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            cmp.setup {
                preselect = cmp.PreselectMode.None,
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'nvim_lua' },
                    { name = 'luasnip' },
                    { name = 'copilot' },
                }, {
                    {
                        name = 'spell',
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end,
                        },
                    },
                    { name = 'path' },
                    { name = 'buffer' },
                    { name = 'crates' },
                }),
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<M-j>'] = cmp.mapping.select_next_item(),
                    ['<M-k>'] = cmp.mapping.select_prev_item(),
                    ['<M-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                formatting = {
                    format =
                        function(entry, vim_item)
                            CMP_WIDTH = 80 -- unknown item kinds will blow this, but let's deal with it once it happens
                            local abbr = vim.fn.strcharpart(vim_item.abbr, 0, CMP_WIDTH - 1)
                            if #abbr < #vim_item.abbr then
                                vim_item.abbr = abbr .. '…'
                            end
                            if #vim_item.abbr < CMP_WIDTH then
                                vim_item.abbr = vim_item.abbr .. (' '):rep(CMP_WIDTH - #abbr - 1)
                            end
                            if vim_item.kind == 'Copilot' then
                                vim_item.kind = ''
                                return vim_item
                            end
                            return lsp_cmp_format(entry, vim_item)
                        end
                },
                view = {
                    entries = { name = 'custom', selection_order = 'near_cursor' },
                },
                window = {
                    documentation = {
                        border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' }
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
                }
            })

            -- `:` cmdline setup.
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
