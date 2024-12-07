-- Language Server Protocol

local decl_syms = { 'File', 'Module', 'Namespace', 'Package', 'Class', 'Method',
    'Field', 'Constructor', 'Enum', 'Interface', 'Function', 'EnumMember', 'Struct',
}

local function document_symbols()
    local win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(win)
    vim.lsp.buf_request(bufnr, vim.lsp.protocol.Methods.textDocument_documentSymbol,
        vim.lsp.util.make_position_params(win),
        function(_, result)
            local items = vim.lsp.util.symbols_to_items(result, bufnr)
            local decls = vim.tbl_filter(function(item) return vim.tbl_contains(decl_syms, item.kind) end, items)
            vim.fn.setloclist(win, {}, ' ', { title = 'Document symbols', items = decls })
            if vim.api.nvim_get_current_win() == win then
                vim.cmd.lopen()
            end
        end)
end

local function workspace_symbols()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.buf_request(bufnr, vim.lsp.protocol.Methods.workspace_symbol, { query = '' },
        function(_, result)
            local items = vim.lsp.util.symbols_to_items(result, bufnr)
            local decls = vim.tbl_filter(function(item) return vim.tbl_contains(decl_syms, item.kind) end, items)
            vim.fn.setqflist({}, ' ', { title = 'Workspace symbols', items = decls })
            vim.cmd.copen()
        end)
end

local function on_attach(client, bufnr, opts)
    opts = opts or {}
    opts.autoformat = opts.autoformat ~= false
    -- Highlight matching identifiers
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            callback = function()
                vim.lsp.buf.clear_references()
                vim.lsp.buf.document_highlight()
            end,
            buffer = bufnr,
        })
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
        vim.keymap.set({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })
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
            'onsails/lspkind-nvim',
            'mrcjkb/rustaceanvim',
            { 'folke/lazydev.nvim', opts = {}, },
            'kosayoda/nvim-lightbulb',
        },
        config = setup_lsp,
        ft = { 'bash', 'c', 'cpp', 'css', 'go', 'haskell', 'html', 'javascript', 'json', 'lua',
            'markdown', 'typescript', 'yaml', 'python', 'rust', 'zig', 'zsh' },
    },
}
