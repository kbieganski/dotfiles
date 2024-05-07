-- Language Server Protocol

local highlight_refs_group = vim.api.nvim_create_augroup('lsp_highlight_refs', {})

local function highlight_refs()
    vim.lsp.buf.clear_references()
    vim.lsp.buf.document_highlight()
end

local function on_attach(client, bufnr)
    local telescope_builtin = require 'telescope.builtin'
    -- Highlight matching identifiers
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            callback = highlight_refs,
            buffer = bufnr,
            group = highlight_refs_group,
        })
    end
    if client.server_capabilities.documentSymbolProvider then
        require 'nvim-navic'.attach(client, bufnr)
    end
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next { float = false } end,
        { buffer = bufnr, silent = true, desc = 'Next diagnostic' })
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev { float = false } end,
        { buffer = bufnr, silent = true, desc = 'Previous diagnostic' })
    vim.keymap.set('n', '-', function() telescope_builtin.diagnostics { bufnr = 0 } end,
        { buffer = bufnr, silent = true, desc = 'All diagnostics' })
    vim.keymap.set('n', '_', telescope_builtin.diagnostics, { buffer = bufnr, silent = true, desc = 'All diagnostics' })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, silent = true, desc = 'Hover' })
    vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action,
        { buffer = bufnr, silent = true, desc = 'Code action' })
    vim.keymap.set('n', '<leader>n', vim.lsp.buf.rename, { buffer = bufnr, silent = true, desc = 'Rename symbol' })
    vim.keymap.set('n', '<leader>m', telescope_builtin.lsp_document_symbols,
        { buffer = bufnr, silent = true, desc = 'Find symbol' })
    vim.keymap.set('n', '<leader>M', telescope_builtin.lsp_workspace_symbols,
        { buffer = bufnr, silent = true, desc = 'Find workspace symbol' })
    vim.keymap.set('n', 'gc', telescope_builtin.lsp_incoming_calls, { buffer = bufnr, silent = true, desc = 'Caller' })
    vim.keymap.set('n', 'gC', telescope_builtin.lsp_outgoing_calls, { buffer = bufnr, silent = true, desc = 'Callee' })
    vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, { buffer = bufnr, silent = true, desc = 'Definition' })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, silent = true, desc = 'Declaration' })
    vim.keymap.set('n', 'gt', telescope_builtin.lsp_type_definitions,
        { buffer = bufnr, silent = true, desc = 'Type definition' })
    vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, { buffer = bufnr, silent = true, desc = 'Reference' })
    vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations,
        { buffer = bufnr, silent = true, desc = 'Implementation' })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single", })
end

return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'folke/neodev.nvim', },
            { 'kosayoda/nvim-lightbulb', },
            { 'SmiteshP/nvim-navic', },
            { 'lukas-reineke/lsp-format.nvim', },
        },
        config = function()
            vim.diagnostic.config { virtual_text = false, update_in_insert = true }

            -- pretty LSP diagnostics icons
            for name, icon in pairs { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' } do
                vim.fn.sign_define('DiagnosticSign' .. name, { text = icon, texthl = 'Diagnostic' .. name })
            end

            -- enable completion capabilities for LSP
            local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

            local lspconfig = require 'lspconfig'

            for _, server in pairs { 'gopls', 'hls', 'marksman', 'zls' } do
                lspconfig[server].setup {
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                        on_attach(client, bufnr)
                        require 'lsp-format'.on_attach(client)
                    end,
                }
            end

            lspconfig.clangd.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)
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
                on_attach = on_attach,
            }

            lspconfig.pylsp.setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    pylsp = {
                        plugins = {
                            pylsp_mypy = { enabled = true, }
                        }
                    }
                }
            }

            require 'neodev'.setup()
            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)
                    require 'lsp-format'.on_attach(client)
                end,
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT', },
                        workspace = { library = vim.api.nvim_get_runtime_file('', true), },
                        telemetry = { enable = false, },
                    }
                },
            }

            require 'nvim-lightbulb'.setup {
                sign = { text = '󰘦 ', hl = 'Normal' },
                autocmd = { enabled = true },
            }
        end,
        ft = { 'c', 'cpp', 'go', 'haskell', 'lua', 'markdown', 'python' },
    },
    {
        'mrcjkb/rustaceanvim',
        config = function()
            local capabilities = require 'cmp_nvim_lsp'.default_capabilities()
            vim.g.rustaceanvim = {
                tools = {
                    inlay_hints = { only_current_line = true, },
                },
                server = {
                    settings = {
                        ['rust-analyzer'] = {
                            cargo = { features = 'all', },
                        },
                        procMacro = {
                            enable = true,
                            attributes = { enable = true, },
                        },
                    },
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                        on_attach(client, bufnr)
                        require 'lsp-format'.on_attach(client)
                    end,
                },
            }
        end,
        ft = 'rust',
    },
}
