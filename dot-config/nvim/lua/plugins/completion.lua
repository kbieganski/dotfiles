return {
    {
        'saghen/blink.cmp',
        lazy = false, -- lazy loading handled internally
        version = 'v1.*',
        config = function()
            require 'blink.cmp'.setup {
                sources = {
                    default = { 'lsp', 'path', 'buffer' },
                },
                completion = {
                    menu = { border = 'none' },
                    documentation = { auto_show = true },
                },
                cmdline = {
                    completion = { menu = { auto_show = true } },
                },
            }
        end,
        dependencies = { 'onsails/lspkind-nvim', }
    },
}
