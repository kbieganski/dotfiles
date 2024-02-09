local function insert_markdown_link()
    local url = vim.fn.getreg "+"
    if url == "" then return end
    local cmd = "curl -L " .. vim.fn.shellescape(url) .. " 2>/dev/null"
    local handle = io.popen(cmd)
    if not handle then return end
    local html = handle:read "*a"
    handle:close()
    local title = ""
    local pattern = "<title>(.-)</title>"
    local m = string.match(html, pattern)
    if m then title = m end
    if title ~= "" then
        local pos = vim.api.nvim_win_get_cursor(0)[2]
        local line = vim.api.nvim_get_current_line()
        local link = "[" .. title .. "](" .. url .. ")"
        local new_line = line:sub(0, pos) .. link .. line:sub(pos + 1)
        vim.api.nvim_set_current_line(new_line)
    else
        vim.notify("Title not found for link")
    end
end


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
            vim.opt_local.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end
        vim.keymap.set('n', ']e', vim.diagnostic.goto_next,
            { buffer = bufnr, silent = true, desc = 'Next diagnostic' })
        vim.keymap.set('n', '[e', vim.diagnostic.goto_prev,
            { buffer = bufnr, silent = true, desc = 'Previous diagnostic' })
        vim.keymap.set('n', '<localleader>e', require 'diagline_popup'.show,
            { buffer = bufnr, silent = true, desc = 'Line diagnostics' })
        vim.keymap.set('n', '<localleader>E', telescope_builtin.diagnostics,
            { buffer = bufnr, silent = true, desc = 'All diagnostics' })
        vim.keymap.set('n', '<localleader>h', vim.lsp.buf.hover,
            { buffer = bufnr, silent = true, desc = 'Hover' })
        vim.keymap.set('n', '<localleader>o', require 'symbols-outline'.toggle_outline,
            { buffer = bufnr, silent = true, desc = 'Symbol outline' })
        for _, mode in ipairs { 'n', 'v' } do
            vim.keymap.set(mode, '<localleader>a', vim.lsp.buf.code_action,
                { buffer = bufnr, silent = true, desc = 'Code action' })
            vim.keymap.set(mode, '<localleader>f', vim.lsp.buf.format,
                { buffer = bufnr, silent = true, desc = 'Apply formatting' })
        end
        vim.keymap.set('n', '<localleader>k', vim.lsp.buf.signature_help,
            { buffer = bufnr, silent = true, desc = 'Signature help' })
        vim.keymap.set('n', '<localleader>r', vim.lsp.buf.rename,
            { buffer = bufnr, silent = true, desc = 'Rename symbol' })
        vim.keymap.set('n', '<localleader>s', telescope_builtin.lsp_document_symbols,
            { buffer = bufnr, silent = true, desc = 'Find symbol' })
        vim.keymap.set('n', '<localleader>S', telescope_builtin.lsp_workspace_symbols,
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
            { 'folke/neodev.nvim',                            lazy = true, opts = {} }, -- LSP for neovim config/plugin dev
            { 'jubnzv/virtual-types.nvim',                    lazy = true },            -- code lens types
            { 'kosayoda/nvim-lightbulb',                      lazy = true },            -- code action lightbulb
            { 'SmiteshP/nvim-navic',                          lazy = true, opts = {} }, -- breadcrumbs
            { 'lukas-reineke/lsp-format.nvim',                lazy = true, opts = {} }, -- auto format
            { 'hrsh7th/cmp-nvim-lsp',                         lazy = true },
            {
                'simrat39/symbols-outline.nvim',
                lazy = true,
                opts = { autofold_depth = 2 }
            },
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
                    vim.keymap.set('n', '<localleader>p', insert_markdown_link, { silent = true, desc = 'Paste link' })
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
                    vim.keymap.set('n', 'go', ':ClangdSwitchSourceHeader<CR>',
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
                on_attach = on_attach { autoformat = false },
            }

            require 'neodev'.setup {}

            lspconfig.lua_ls.setup {
                on_attach = on_attach { autoformat = false },
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace'
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
                            library = vim.api.nvim_get_runtime_file('', true),
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    }
                },
            }

            require 'nvim-lightbulb'.setup { autocmd = { enabled = true } }
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
                        vim.keymap.set('n', '<localleader><CR>', rust_tools.debuggables.debuggables,
                            { buffer = bufnr, desc = 'Debuggables' })
                    end,
                },
            }
        end,
        dependencies = { 'neovim/nvim-lspconfig' },
        ft = 'rust',
    },
}
