-- Language Server Protocol

local function on_attach(opts)
    vim.diagnostic.config { virtual_text = false }
    local telescope_builtin = require 'telescope.builtin'
    opts = opts or {}
    if opts.virtual_types == nil then opts.virtual_types = true end
    return function(client, bufnr)
        if client.server_capabilities.documentHighlightProvider then
            local augroup = 'lsp_document_highlight'
            vim.api.nvim_create_augroup(augroup, { clear = true })
            vim.api.nvim_clear_autocmds { buffer = bufnr, group = augroup }
            local highlight_refs = function()
                vim.lsp.buf.clear_references()
                vim.lsp.buf.document_highlight()
            end
            vim.api.nvim_create_autocmd("CursorHold", {
                callback = highlight_refs,
                buffer = bufnr,
                group = augroup,
            })
            vim.api.nvim_create_autocmd("CursorHoldI", {
                callback = highlight_refs,
                buffer = bufnr,
                group = augroup,
            })
        end
        if opts.autoformat then
            require 'lsp-format'.on_attach(client)
        end
        if opts.virtual_types then
            require 'virtualtypes'.on_attach(client, bufnr)
        end
        if client.server_capabilities.documentSymbolProvider then
            require 'nvim-navic'.attach(client, bufnr)
        end
        vim.keymap.set('n', ']-', function() vim.diagnostic.goto_next { float = false } end,
            { buffer = bufnr, silent = true, desc = 'Next diagnostic' })
        vim.keymap.set('n', '[-', function() vim.diagnostic.goto_prev { float = false } end,
            { buffer = bufnr, silent = true, desc = 'Previous diagnostic' })
        vim.keymap.set('n', '-', function() telescope_builtin.diagnostics { bufnr = 0 } end,
            { buffer = bufnr, silent = true, desc = 'All diagnostics' })
        vim.keymap.set('n', '_', telescope_builtin.diagnostics,
            { buffer = bufnr, silent = true, desc = 'All diagnostics' })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover,
            { buffer = bufnr, silent = true, desc = 'Hover' })
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "single",
        })
        for _, mode in ipairs { 'n', 'v' } do
            vim.keymap.set(mode, '<M-a>', vim.lsp.buf.code_action,
                { buffer = bufnr, silent = true, desc = 'Code action' })
            vim.keymap.set(mode, '<M-f>', vim.lsp.buf.format,
                { buffer = bufnr, silent = true, desc = 'Apply formatting' })
        end
        vim.keymap.set('n', '<M-r>', vim.lsp.buf.rename,
            { buffer = bufnr, silent = true, desc = 'Rename symbol' })
        vim.keymap.set('n', 'm', telescope_builtin.lsp_document_symbols,
            { buffer = bufnr, silent = true, desc = 'Find symbol' })
        vim.keymap.set('n', '<M-m>', telescope_builtin.lsp_workspace_symbols,
            { buffer = bufnr, silent = true, desc = 'Find workspace symbol' })
        vim.keymap.set('n', 'gc', telescope_builtin.lsp_incoming_calls,
            { buffer = bufnr, silent = true, desc = 'Caller' })
        vim.keymap.set('n', 'gC', telescope_builtin.lsp_outgoing_calls,
            { buffer = bufnr, silent = true, desc = 'Callee' })
        vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions,
            { buffer = bufnr, silent = true, desc = 'Definition' })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
            { buffer = bufnr, silent = true, desc = 'Declaration' })
        vim.keymap.set('n', 'gt', telescope_builtin.lsp_type_definitions,
            { buffer = bufnr, silent = true, desc = 'Type definition' })
        vim.keymap.set('n', 'gr', telescope_builtin.lsp_references,
            { buffer = bufnr, silent = true, desc = 'Reference' })
        vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations,
            { buffer = bufnr, silent = true, desc = 'Implementation' })
    end
end

return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'folke/neodev.nvim', },             -- LSP for neovim config/plugin dev
            { 'jubnzv/virtual-types.nvim', },     -- code lens types
            { 'kosayoda/nvim-lightbulb', },       -- code action lightbulb
            { 'SmiteshP/nvim-navic', },           -- breadcrumbs
            { 'lukas-reineke/lsp-format.nvim', }, -- auto format
            { 'hrsh7th/cmp-nvim-lsp', },
        },
        config = function()
            -- pretty LSP diagnostics icons
            for name, icon in pairs { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' } do
                vim.fn.sign_define('DiagnosticSign' .. name, { text = icon, texthl = 'Diagnostic' .. name })
            end

            -- enable completion capabilities for LSP
            local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

            local lspconfig = require 'lspconfig'

            lspconfig.marksman.setup {
                on_attach = function(client, bufnr)
                    on_attach {} (client, bufnr)
                end,
            }

            for _, server in pairs { 'gopls', 'hls', 'tsserver', 'templ' } do
                lspconfig[server].setup {
                    capabilities = capabilities,
                    on_attach = on_attach { autoformat = true },
                }
            end

            lspconfig.clangd.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    on_attach { autoformat = false, virtual_types = false } (client, bufnr)
                    vim.keymap.set('n', 'go', function() vim.cmd.ClangdSwitchSourceHeader() end,
                        { buffer = bufnr, desc = 'Switch source/header' })
                end,
                cmd = {
                    "clangd",
                    "--offset-encoding=utf-16",
                },
            }

            lspconfig.verible.setup {
                capabilities = capabilities,
                on_attach = on_attach { autoformat = false },
            }

            lspconfig.pylsp.setup {
                capabilities = capabilities,
                on_attach = on_attach { autoformat = false },
                settings = {
                    pylsp = {
                        plugins = {
                            pylsp_mypy = {
                                enabled = true,
                            }
                        }
                    }
                }
            }

            lspconfig.zls.setup {
                capabilities = capabilities,
                on_attach = on_attach { autoformat = true },
            }

            require 'neodev'.setup()
            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                on_attach = on_attach { autoformat = true },
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = { 'vim' },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file('', true),
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    }
                },
            }

            require 'nvim-lightbulb'.setup {
                sign = { text = '' },
                autocmd = { enabled = true },
            }
        end,
        filetype = { 'c', 'cpp', 'go', 'haskell', 'javascript', 'lua', 'markdown', 'python', 'rust', 'typescript' },
    },
    {
        'simrat39/rust-tools.nvim', -- Rust-specific plugin
        config = function()
            local capabilities = require 'cmp_nvim_lsp'.default_capabilities()
            local rust_tools = require 'rust-tools'
            rust_tools.setup {
                tools = {
                    inlay_hints = {
                        only_current_line = true,
                    },
                },
                server = {
                    settings = {
                        ['rust-analyzer'] = {
                            cargo = {
                                features = 'all',
                            },
                        },
                        procMacro = {
                            enable = true,
                            attributes = {
                                enable = true,
                            },
                        },
                    },
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                        on_attach { autoformat = true, virtual_types = false } (client, bufnr)
                        vim.keymap.set('n', '<CR>d', rust_tools.debuggables.debuggables,
                            { buffer = bufnr, desc = 'Debuggables' })
                    end,
                },
            }
        end,
        dependencies = { 'neovim/nvim-lspconfig' },
        ft = 'rust',
    },
}
