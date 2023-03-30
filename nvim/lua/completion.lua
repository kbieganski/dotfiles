------------------
--- Completion ---
------------------
local M = {}

function M.capabilities()
    return require 'cmp_nvim_lsp'.default_capabilities()
end

function M.setup()
    local cmp = require 'cmp'
    local lsp_cmp_format = require 'lspkind'.cmp_format { mode = 'symbol' }
    cmp.setup {
        preselect = cmp.PreselectMode.None,
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "nvim_lua" },
            { name = "vsnip" },
            { name = "copilot" },
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
            { name = "path" },
            { name = "buffer" },
            { name = "crates" },
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
                ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
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

    cmp.setup.cmdline({'/', '?'}, {
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.cmdline{
            ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        },
        sources = {
            { name = 'buffer' }
        }
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.cmdline{
            ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        },
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        }, {
            { name = 'buffer' }
        })
    })

    require 'copilot'.setup {
        -- as recommended by copilot_cmp readme, disable these:
        suggestion = { enabled = false },
        panel = { enabled = false },
    }
    require 'copilot_cmp'.setup()
end

return M
