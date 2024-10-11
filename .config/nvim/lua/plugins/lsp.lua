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
    if client.server_capabilities.inlayHintProvider then
        -- vim.lsp.inlay_hint.enable(true)
    end
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next { float = false } end,
        { buffer = bufnr, silent = true, desc = 'Next diagnostic' })
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev { float = false } end,
        { buffer = bufnr, silent = true, desc = 'Previous diagnostic' })
    vim.keymap.set('n', '<leader>d', function() telescope_builtin.diagnostics { bufnr = bufnr } end,
        { buffer = bufnr, silent = true, desc = 'Buffer diagnostics' })
    vim.keymap.set('n', '<leader>D', telescope_builtin.diagnostics,
        { buffer = bufnr, silent = true, desc = 'All diagnostics' })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, silent = true, desc = 'Hover' })
    vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action,
        { buffer = bufnr, silent = true, desc = 'Code action' })
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { buffer = bufnr, silent = true, desc = 'Rename symbol' })
    vim.keymap.set('n', '<leader>m', telescope_builtin.lsp_document_symbols,
        { buffer = bufnr, silent = true, desc = 'Find symbol' })
    vim.keymap.set('n', '<leader>M', telescope_builtin.lsp_workspace_symbols,
        { buffer = bufnr, silent = true, desc = 'Find workspace symbol' })
    vim.keymap.set('n', 'gci', telescope_builtin.lsp_incoming_calls,
        { buffer = bufnr, silent = true, desc = 'Incoming calls' })
    vim.keymap.set('n', 'gco', telescope_builtin.lsp_outgoing_calls,
        { buffer = bufnr, silent = true, desc = 'Outgoing calls' })
    vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, { buffer = bufnr, silent = true, desc = 'Definition' })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, silent = true, desc = 'Declaration' })
    vim.keymap.set('n', 'gt', telescope_builtin.lsp_type_definitions,
        { buffer = bufnr, silent = true, desc = 'Type definition' })
    vim.keymap.set('n', 'gq', vim.lsp.buf.format, { buffer = bufnr, silent = true, desc = 'Format entire buffer' })
    vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, { buffer = bufnr, silent = true, desc = 'Reference' })
    vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations,
        { buffer = bufnr, silent = true, desc = 'Implementation' })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single", })
end

local autoformat_group = vim.api.nvim_create_augroup('autoformat', { clear = false }) -- Do not clear, otherwise it breaks autoformat on config reload
local function setup_autoformat(bufnr)
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        group = autoformat_group,
        buffer = bufnr,
        callback = function() vim.lsp.buf.format { buffer = bufnr } end,
    })
end

return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'kosayoda/nvim-lightbulb', },
            { 'SmiteshP/nvim-navic', },
            { 'folke/lazydev.nvim',      opts = {}, },
        },
        config = function()
            -- enable completion capabilities for LSP
            local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

            local lspconfig = require 'lspconfig'

            for _, server in pairs { 'bashls', 'cssls', 'gopls', 'hls', 'html', 'jsonls', 'marksman', 'ts_ls', 'yamlls', 'zls' } do
                lspconfig[server].setup {
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                        on_attach(client, bufnr)
                        setup_autoformat(bufnr)
                    end,
                }
            end

            lspconfig.clangd.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)
                    vim.keymap.set('n', 'go', vim.cmd.ClangdSwitchSourceHeader,
                        { buffer = bufnr, desc = 'Switch source/header' })
                end,
                cmd = {
                    "clangd",
                    "--offset-encoding=utf-16",
                },
            }

            lspconfig.svls.setup {
                cmd = { 'target/debug/svls' },
                filetypes = 'systemverilog',
                name = 'svls',
                capabilities = capabilities,
                on_attach = on_attach,
            }

            vim.lsp.buf.incoming_calls()
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

            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)
                    setup_autoformat(bufnr)
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
                        setup_autoformat(bufnr)
                    end,
                },
            }
        end,
        ft = 'rust',
    },
}
