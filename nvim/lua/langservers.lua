-----------–------------
--- Language servers ---
------------------------

local M = {}

function M.toggle_lines()
    M.lines_enabled = not M.lines_enabled
    vim.diagnostic.config { virtual_lines = M.lines_enabled, virtual_text = not M.lines_enabled }
end

function M.setup(wk)
    local hover = require 'hover'
    hover.setup {
        init = function()
            require 'hover.providers.lsp'
            require 'hover.providers.gh'
            require 'hover.providers.gh_user'
            require 'hover.providers.man'
            require 'hover.providers.dictionary'
        end,
    }

    -- pretty LSP diagnostics icons
    for icon_name, icon in pairs { Error = " ", Warning = " ", Hint = " ", Information = " " } do
        local hl = "LspDiagnosticsSign" .. icon_name
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    local telescope_builtin = require 'telescope.builtin'
    local function on_attach(opts)
        opts = opts or {}
        return function(client, bufnr)
            require 'illuminate'.on_attach(client)
            if opts.autoformat then
                require 'lsp-format'.on_attach(client)
            end
            if client.server_capabilities.documentSymbolProvider then
                require 'nvim-navic'.attach(client, bufnr)
                vim.opt_local.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
            end
            wk.register({
                d = { vim.diagnostic.open_float, "Show this diagnostic" },
                D = { telescope_builtin.diagnostics, "All diagnostics" },
            },
                { prefix = '<leader>', buffer = bufnr })
            wk.register({
                a = { vim.lsp.buf.code_action, "Code action" },
                F = { vim.lsp.buf.format, "Format current file" },
            },
                { mode = { 'n', 'v' }, prefix = '<leader>', buffer = bufnr })
            local dap = require 'dap'
            wk.register({
                x = {
                    b = { dap.toggle_breakpoint, "Breakpoint" },
                    c = { dap.continue, "Continue" },
                    j = { dap.step_into, "Step into" },
                    k = { dap.step_out, "Step out" },
                    l = { dap.step_over, "Step over" },
                },
                h = { hover.hover, "Show symbol info" },
                H = { hover.hover_select, "Show symbol info (select)" },
                k = { vim.lsp.buf.signature_help, "Show signature" },
                r = { vim.lsp.buf.rename, "Rename symbol" },
                s = { telescope_builtin.lsp_document_symbols, "Find symbol" },
                S = { telescope_builtin.lsp_workspace_symbols, "Find workspace symbol" },
            },
                { mode = 'n', prefix = '<leader>', buffer = bufnr })
            wk.register({
                g = {
                    c = { telescope_builtin.lsp_incoming_calls, "Caller" },
                    C = { telescope_builtin.lsp_outgoing_calls, "Callee" },
                    d = { telescope_builtin.lsp_definitions, "Definition" },
                    D = { vim.lsp.buf.declaration, "Declaration" },
                    t = { telescope_builtin.lsp_type_definitions, "Type definition" },
                    r = { telescope_builtin.lsp_references, "Reference" },
                    i = { telescope_builtin.lsp_implementations, "Implementation" },
                },
            }, { buffer = bufnr })
            wk.register({ ['<leader>j'] = { M.toggle_lines, "Show diagnostic lines" } }, { buffer = bufnr })
        end
    end

    -- enable completion capabilities for LSP
    local capabilities = require 'completion'.capabilities()

    local lspconfig = require 'lspconfig'
    for _, server in pairs { 'gopls', 'hls', 'tsserver', 'verible' } do
        lspconfig[server].setup {
            capabilities = capabilities,
            on_attach = on_attach { autoformat = true },
        }
    end

    lspconfig.clangd.setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            on_attach { autoformat = false } (client, bufnr)
            wk.register({
                g = {
                    o = { ':ClangdSwitchSourceHeader<CR>', "Source/header" },
                },
            }, { buffer = bufnr })
        end,
    }

    lspconfig.pylsp.setup {
        --cmd = { 'python', '-m', 'cProfile', '-o', '/home/krzysztof/pylsp-profile', '-m', 'pylsp' },
        capabilities = capabilities,
        on_attach = on_attach { autoformat = true },
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

    require("neodev").setup {
        -- add any options here, or leave empty to use the default settings
    }

    -- example to setup lua_ls and enable call snippets
    lspconfig.lua_ls.setup {
        on_attach = on_attach { autoformat = true },
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace"
                },
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            }
        },
    }

    -- Rust
    -- (this sets up rust-analyzer, so don't do it above)
    require 'rust-tools'.setup {
        tools = {
            inlay_hints = {
                highlight = 'LineNr',
            },
        },
        server = {
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        features = 'all',
                    },
                },
            },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach { autoformat = true } (client, bufnr)
                wk.register({
                    x = {
                        x = { require 'rust-tools'.debuggables.debuggables, "Debuggables" },
                    },
                },
                    { prefix = '<leader>', buffer = bufnr })
            end,
        },
    }
    require 'crates'.setup()

    -- LSP diagnostic lines
    require 'lsp_lines'.setup()
    M.toggle_lines()
end

return M
