-- Language Server Protocol

local decl_syms = vim.iter {
    'File', 'Module', 'Namespace', 'Package', 'Class', 'Method', 'Field', 'Constructor', 'Enum', 'Interface', 'Function', 'EnumMember', 'Struct',
}:map(function(sym) return vim.lsp.protocol.SymbolKind[sym] end):totable()

local function filter_decls(syms)
    local decls = vim.tbl_filter(function(item) return vim.tbl_contains(decl_syms, item.kind) end, syms)
    for _, decl in ipairs(decls) do
        decl.children = decl.children and filter_decls(decl.children)
    end
    return decls
end

local function document_symbols()
    local win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(win)
    for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
        local method = vim.lsp.protocol.Methods.textDocument_documentSymbol
        local position_params = vim.lsp.util.make_position_params(win, client.offset_encoding)
        local handler = function(_, syms)
            if not syms then return end
            local decls = filter_decls(syms)
            local items = vim.lsp.util.symbols_to_items(decls, bufnr)
            vim.fn.setloclist(win, {}, ' ', { title = 'Document symbols', items = items })
            if vim.api.nvim_get_current_win() == win then
                vim.cmd.lopen()
            end
        end
        client.request(method, position_params, handler, bufnr)
    end
end

local function workspace_symbols()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.buf_request(bufnr, vim.lsp.protocol.Methods.workspace_symbol, { query = '' },
        function(_, syms)
            local decls = filter_decls(syms)
            local items = vim.lsp.util.symbols_to_items(decls, bufnr)
            vim.fn.setqflist({}, ' ', { title = 'Workspace symbols', items = items })
            vim.cmd.copen()
        end)
end

local function on_attach(client, bufnr, opts)
    opts = opts or {}
    opts.autoformat = opts.autoformat ~= false
    client.server_capabilities.semanticTokensProvider = nil
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            callback = function()
                vim.lsp.buf.clear_references()
                vim.lsp.buf.document_highlight()
            end,
            buffer = bufnr,
        })
    end
    if client.server_capabilities.inlayHintProvider then
        vim.keymap.set('n', '<leader>i',
            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
            { buffer = bufnr, desc = 'Inlay hints' })
    end
    if client.server_capabilities.workspaceSymbolProvider then
        vim.keymap.set('n', '<leader>J', workspace_symbols, { buffer = bufnr, desc = 'Workspace symbols' })
    end
    if client.server_capabilities.documentSymbolProvider then
        vim.keymap.set('n', '<leader>j', document_symbols, { buffer = bufnr, desc = 'Document symbols' })
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
        vim.keymap.set('n', 'cn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename symbol' })
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
        vim.keymap.set({ 'n', 'v' }, 'gq', vim.lsp.buf.format, { buffer = bufnr, desc = 'Format' })
        vim.keymap.set({ 'n', 'v' }, '=', vim.lsp.buf.format, { buffer = bufnr, desc = 'Format' })
        vim.keymap.set('n', '<leader>F',
            function() vim.api.nvim_buf_set_var(bufnr, 'autoformat', not vim.api.nvim_buf_get_var(bufnr, 'autoformat')) end,
            { buffer = bufnr, desc = 'Toggle auto-formatting' })
        vim.api.nvim_buf_set_var(bufnr, 'autoformat', opts.autoformat)
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
                if vim.api.nvim_buf_get_var(bufnr, 'autoformat') then
                    vim.lsp.buf.format { buffer = bufnr }
                end
            end,
        })
    end
    if client.server_capabilities.referencesProvider then
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = 'Reference' })
    end
    if client.server_capabilities.implementationProvider then
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Implementation' })
    end
end

local function setup_lsp()
    local lspconfig = require 'lspconfig'

    for _, server in ipairs { 'bashls', 'cssls', 'gopls', 'html', 'jsonls', 'marksman', 'ts_ls', 'yamlls', 'zls' } do
        lspconfig[server].setup { on_attach = on_attach }
    end

    lspconfig.clangd.setup {
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
            {
                'onsails/lspkind-nvim',
                config = function()
                    local lspkind = require 'lspkind'
                    lspkind.setup {
                        mode = 'symbol',
                        symbol_map = {
                            Package = '󰆦 ',
                            Namespace = '󰅩 ',
                        },
                    }
                    for i, kind in ipairs(vim.lsp.protocol.SymbolKind) do
                        vim.lsp.protocol.SymbolKind[i] = lspkind.symbolic(kind) .. ' ' .. kind
                    end
                end
            },
            'mrcjkb/rustaceanvim',
            'kosayoda/nvim-lightbulb',
        },
        config = setup_lsp,
        ft = { 'bash', 'c', 'cpp', 'css', 'go', 'html', 'javascript', 'json', 'lua',
            'markdown', 'typescript', 'yaml', 'python', 'rust', 'zig', 'zsh' },
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
        dependencies = { 'neovim/nvim-lspconfig' }
    },
}
