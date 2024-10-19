-- Language Server Protocol

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

local decl_syms = { 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 22, 23 }

local function document_symbols()
    local win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(win)
    vim.lsp.buf_request(bufnr, 'textDocument/documentSymbol', vim.lsp.util.make_position_params(win),
        function(_, result, _)
            local decls = vim.tbl_filter(function(symbol) return vim.tbl_contains(decl_syms, symbol.kind) end, result)
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
            local decls = vim.tbl_filter(function(symbol) return vim.tbl_contains(decl_syms, symbol.kind) end, result)
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

local function on_attach(client, bufnr, opts)
    opts = opts or {}
    opts.autoformat = opts.autoformat or true
    -- Highlight matching identifiers
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            callback = highlight_refs,
            buffer = bufnr,
        })
    end
    if client.server_capabilities.workspaceSymbolProvider then
        vim.keymap.set('n', '<leader>M', workspace_symbols, { buffer = bufnr, desc = 'Workspace symbols' })
    end
    if client.server_capabilities.documentSymbolProvider then
        require 'nvim-navic'.attach(client, bufnr)
        vim.keymap.set('n', '<leader>m', document_symbols, { buffer = bufnr, desc = 'Document symbols' })
    end
    if client.server_capabilities.incomingCallsProvider then
        vim.keymap.set('n', 'gci', vim.lsp.buf.incoming_calls, { buffer = bufnr, desc = 'Incoming calls' })
    end
    if client.server_capabilities.outgoingCallsProvider then
        vim.keymap.set('n', 'gco', vim.lsp.buf.outgoing_calls, { buffer = bufnr, desc = 'Outgoing calls' })
    end
    if client.server_capabilities.codeActionProvider then
        vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })
    end
    if client.server_capabilities.renameProvider then
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename symbol' })
    end
    if client.server_capabilities.definitionProvider then
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Definition' })
    end
    if client.server_capabilities.declarationProvider then
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Declaration' })
    end
    if client.server_capabilities.typeDefinitionProvider then
        vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Type definition' })
    end
    if client.server_capabilities.typeHierarchyProvider then
        vim.keymap.set('n', 'gh', vim.lsp.buf.typehierarchy, { buffer = bufnr, desc = 'Type hierarchy' })
    end
    if client.server_capabilities.documentFormattingProvider then
        vim.keymap.set('n', 'gq', vim.lsp.buf.format, { buffer = bufnr, desc = 'Format entire buffer' })
        if opts.autoformat then
            vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
                buffer = bufnr,
                callback = function() vim.lsp.buf.format { buffer = bufnr } end,
            })
        end
    end
    if client.server_capabilities.referencesProvider then
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = 'Reference' })
    end
    if client.server_capabilities.implementationProvider then
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Implementation' })
    end
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
    end
    vim.keymap.set('n', '<leader>d', buffer_diagnostics, { buffer = bufnr, desc = 'Document diagnostics' })
    vim.keymap.set('n', '<leader>D', all_diagnostics, { buffer = bufnr, desc = 'All diagnostics' })
end

local function setup_lsp()
    -- enable completion capabilities for LSP
    local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

    local lspconfig = require 'lspconfig'

    for _, server in ipairs { 'bashls', 'cssls', 'gopls', 'hls', 'html', 'jsonls', 'marksman', 'ts_ls', 'yamlls', 'zls' } do
        lspconfig[server].setup {
            capabilities = capabilities,
            on_attach = on_attach,
        }
    end


    lspconfig.clangd.setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            on_attach(client, bufnr, { autoformat = false })
            vim.keymap.set('n', 'go', vim.cmd.ClangdSwitchSourceHeader,
                { buffer = bufnr, desc = 'Switch source/header' })
        end,
        cmd = {
            "clangd",
            "--offset-encoding=utf-16",
        },
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

    lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT', },
                workspace = { library = vim.api.nvim_get_runtime_file('', true), },
                telemetry = { enable = false, },
            }
        },
    }

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
            on_attach = on_attach,
        },
    }

    require 'nvim-lightbulb'.setup {
        sign = { enabled = false },
        virtual_text = { enabled = true, text = '󰘦 ', hl = 'NonText' },
        autocmd = { enabled = true },
    }
end

return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'mrcjkb/rustaceanvim' },
            { 'folke/lazydev.nvim',      opts = {}, },
            { 'kosayoda/nvim-lightbulb', },
            { 'SmiteshP/nvim-navic', },
        },
        config = setup_lsp,
        ft = { 'bash', 'c', 'cpp', 'css', 'go', 'haskell', 'html', 'javascript', 'json', 'lua',
            'markdown', 'typescript', 'yaml', 'python', 'rust', 'zig', 'zsh' },
    },
}
