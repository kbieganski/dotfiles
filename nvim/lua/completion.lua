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
            -- From the cmp wiki:
            -- If nothing is selected (including preselections) add a newline as usual.
            -- If something has explicitly been selected by the user, select it.
                ["<CR>"] = cmp.mapping({
                i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    else
                        fallback()
                    end
                end,
                s = cmp.mapping.confirm({ select = true }),
                c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            }),
        },
        formatting = {
            format =
                function(entry, vim_item)
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

    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
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
