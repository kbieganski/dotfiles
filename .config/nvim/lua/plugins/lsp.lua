-- Language Server Protocol

local highlight_refs_group = vim.api.nvim_create_augroup('lsp_highlight_refs', {})

local function highlight_refs()
    vim.lsp.buf.clear_references()
    vim.lsp.buf.document_highlight()
end

local function all_diagnostics()
    vim.diagnostic.setqflist { title = 'All diangostics' }
end

local function buffer_diagnostics()
    local win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(win)
    local items = vim.diagnostic.toqflist(vim.diagnostic.get(bufnr))
    vim.fn.setloclist(win, {}, ' ', { title = 'Document diagnostics', items = items })
    if vim.api.nvim_get_current_win() == win then
        vim.cmd.lopen()
    end
end

local function document_symbols()
    local win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(win)
    vim.lsp.buf_request(bufnr, 'textDocument/documentSymbol', vim.lsp.util.make_position_params(win),
        function(_, result, ctx)
            local kinds = { 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 22, 23 }
            local decls = vim.tbl_filter(function(symbol) return vim.tbl_contains(kinds, symbol.kind) end, result)
            local items = vim.tbl_map(function(symbol)
                local range = symbol.range
                local start = range.start
                local lnum = start.line + 1
                local col = start.character + 1
                local text = symbol.name ..
                    (symbol.detail and ' | ' .. symbol.detail .. ' (' .. symbol.kind .. ')' or '')
                return { lnum = lnum, col = col, text = text }
            end, decls)
            vim.fn.setloclist(win, {}, ' ', { title = 'Document symbols', items = items })
            if vim.api.nvim_get_current_win() == win then
                vim.cmd.lopen()
            end
        end)
end

local function workspace_symbols()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.buf_request(bufnr, 'workspace/symbol', { query = '' },
        function(_, result, ctx)
            local kinds = { 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 22, 23 }
            local decls = vim.tbl_filter(function(symbol) return vim.tbl_contains(kinds, symbol.kind) end, result)
            local items = vim.lsp.util.symbols_to_items(decls, bufnr)
            local client = vim.lsp.get_clients { bufnr = bufnr, id = ctx.client_id }[1]
            local root = client.config.root_dir
            items = vim.tbl_map(function(item)
                if item.filename:sub(1, #root) == root then
                    item.filename = item.filename:sub(#root + 1)
                    if item.filename:sub(1, 1) == '/' then
                        item.filename = item.filename:sub(2)
                    end
                end
                return item
            end, items)
            vim.fn.setqflist({}, ' ', { title = 'Workspace symbols', items = items })
            vim.cmd.copen()
        end)
end

local function on_attach(client, bufnr)
    -- Highlight matching identifiers
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            callback = highlight_refs,
            buffer = bufnr,
            group = highlight_refs_group,
        })
    end
    if client.server_capabilities.workspaceSymbolProvider then
        vim.keymap.set('n', '<leader>M', workspace_symbols, { buffer = bufnr, silent = true, desc = 'Workspace symbols' })
    end
    if client.server_capabilities.documentSymbolProvider then
        require 'nvim-navic'.attach(client, bufnr)
        vim.keymap.set('n', '<leader>m', document_symbols, { buffer = bufnr, silent = true, desc = 'Document symbols' })
    end
    if client.server_capabilities.incomingCallsProvider then
        vim.keymap.set('n', 'gci', vim.lsp.buf.incoming_calls, { buffer = bufnr, silent = true, desc = 'Incoming calls' })
    end
    if client.server_capabilities.outgoingCallsProvider then
        vim.keymap.set('n', 'gco', vim.lsp.buf.outgoing_calls, { buffer = bufnr, silent = true, desc = 'Outgoing calls' })
    end
    if client.server_capabilities.hoverProvider then
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, silent = true, desc = 'Hover' })
    end
    if client.server_capabilities.codeActionProvider then
        vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action,
            { buffer = bufnr, silent = true, desc = 'Code action' })
    end
    if client.server_capabilities.renameProvider then
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { buffer = bufnr, silent = true, desc = 'Rename symbol' })
    end
    if client.server_capabilities.definitionProvider then
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, silent = true, desc = 'Definition' })
    end
    if client.server_capabilities.declarationProvider then
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, silent = true, desc = 'Declaration' })
    end
    if client.server_capabilities.typeDefinitionProvider then
        vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition,
            { buffer = bufnr, silent = true, desc = 'Type definition' })
    end
    if client.server_capabilities.typeHierarchyProvider then
        vim.keymap.set('n', 'gh', vim.lsp.buf.typehierarchy, { buffer = bufnr, silent = true, desc = 'Type hierarchy' })
    end
    if client.server_capabilities.documentFormattingProvider then
        vim.keymap.set('n', 'gq', vim.lsp.buf.format, { buffer = bufnr, silent = true, desc = 'Format entire buffer' })
    end
    if client.server_capabilities.referencesProvider then
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, silent = true, desc = 'Reference' })
    end
    if client.server_capabilities.implementationProvider then
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, silent = true, desc = 'Implementation' })
    end
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
    end
    vim.keymap.set('n', '<leader>d', buffer_diagnostics, { buffer = bufnr, silent = true, desc = 'Document diagnostics' })
    vim.keymap.set('n', '<leader>D', all_diagnostics, { buffer = bufnr, silent = true, desc = 'All diagnostics' })
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
