------------------
--- Completion ---
------------------
local M = {}

function M.capabilities()
    return require 'cmp_nvim_lsp'.default_capabilities()
end

function M.setup()
    local cmp = require 'cmp'
    cmp.setup {
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "buffer" },
            { name = "nvim_lua" },
            { name = "vsnip" },
            { name = "crates" },
        }, {
            { name = "buffer" },
        }),
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        mapping = {
            ["<M-j>"] = cmp.mapping.select_next_item(),
            ["<M-k>"] = cmp.mapping.select_prev_item(),
            ["<M-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm { select = true },
        },
        formatting = {
            format = require 'lspkind'.cmp_format(),
        },
    }
end

return M
