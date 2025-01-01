return {
    {
        'saghen/blink.cmp',
        lazy = false, -- lazy loading handled internally
        version = 'v0.*',
        config = function()
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local copilot_kind = #CompletionItemKind + 1
            CompletionItemKind[copilot_kind] = 'Copilot'
            require 'blink.cmp'.setup {
                sources = {
                    providers = {
                        copilot = {
                            name = 'copilot',
                            module = 'blink-cmp-copilot',
                            score_offset = 100,
                            async = true,
                            transform_items = function(_, items)
                                for _, item in ipairs(items) do item.kind = copilot_kind end
                                return items
                            end,
                        },
                    },
                    default = { 'lsp', 'path', 'buffer', 'copilot' },
                },
                appearance = {
                    kind_icons = vim.tbl_extend('force', require 'lspkind'.symbol_map, {
                        Copilot = "",
                    }),
                },
                completion = {
                    documentation = { auto_show = true, window = { border = 'single' } },
                },
            }
        end,
        dependencies = {
            'onsails/lspkind-nvim',
            {
                'giuxtaposition/blink-cmp-copilot',
                dependencies = {
                    'zbirenbaum/copilot.lua',
                    event = 'InsertEnter',
                    cmd = 'Copilot',
                    build = ':Copilot auth',
                    opts = {
                        suggestion = { enabled = false },
                        panel = { enabled = false },
                        filetypes = {},
                    },
                },
            },
        },
    },
}
