local function on_attach(opts)
    vim.diagnostic.config { virtual_text = false, virtual_lines = false }
    local telescope_builtin = require 'telescope.builtin'
    opts = opts or {}
    if opts.virtual_types == nil then opts.virtual_types = true end
    return function(client, bufnr)
        require 'illuminate'.on_attach(client)
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
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
            { buffer = bufnr, silent = true, desc = 'Next diagnostic' })
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
            { buffer = bufnr, silent = true, desc = 'Previous diagnostic' })
        vim.keymap.set('n', '<localleader>d', vim.diagnostic.open_float,
            { buffer = bufnr, silent = true, desc = 'Line diagnostics' })
        vim.keymap.set('n', '<localleader>D', telescope_builtin.diagnostics,
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
        vim.keymap.set('n', '<localleader>j', function()
            vim.g.lines_enabled = not vim.g.lines_enabled
            vim.diagnostic.config { virtual_lines = vim.g.lines_enabled }
        end, { buffer = bufnr, silent = true, desc = 'Show diagnostic lines' })
    end
end

return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'folke/neoconf.nvim',                           cmd = 'Neoconf', lazy = true, opts = {} },
            { 'folke/neodev.nvim',                            lazy = true,     opts = {} }, -- LSP for neovim config/plugin dev
            { 'jubnzv/virtual-types.nvim',                    lazy = true },                -- code lens types
            { 'kosayoda/nvim-lightbulb',                      lazy = true },                -- code action lightbulb
            { 'SmiteshP/nvim-navic',                          lazy = true,     opts = {} }, -- breadcrumbs
            { 'lukas-reineke/lsp-format.nvim',                lazy = true,     opts = {} }, -- auto format
            { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', lazy = true,     opts = {} }, -- diagnostic lines
            { 'RRethy/vim-illuminate',                        lazy = true },                -- highlight word under cursor
            {
                'mickael-menu/zk-nvim',
                lazy = true,
                config = function()
                    require 'zk'.setup()
                end
            },
            { 'hrsh7th/cmp-nvim-lsp', lazy = true },
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

            local lsp_configs = require 'lspconfig.configs'

            lsp_configs.prosemd = {
                default_config = {
                    cmd = { vim.fn.expand('$HOME/.cargo/bin/prosemd-lsp'), '--stdio' },
                    filetypes = { 'markdown', 'gitcommit' },
                    root_dir = function(fname)
                        return require 'lspconfig.util'.find_git_ancestor(fname) or vim.fn.getcwd()
                    end,
                    settings = {},
                }
            }

            local lspconfig = require 'lspconfig'
            lspconfig.prosemd.setup {}
            for _, server in pairs { 'gopls', 'hls', 'tsserver' } do
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

            require 'nvim-lightbulb'.setup { sign = { enabled = false }, virtual_text = { enabled = true }, autocmd = {
                enabled = true } }

            vim.keymap.set('n', '<leader>nn', ':ZkNew { title = vim.fn.input("Title: ") }<CR>',
                { silent = true, desc = 'New note' })
            vim.keymap.set('n', '<leader>nf', ':ZkNotes { sort = { "modified" } }<CR>',
                { silent = true, desc = 'Find note' })
            vim.keymap.set('n', '<leader>nb', ':ZkBacklinks<CR>',
                { silent = true, desc = 'Backlinks' })
            vim.keymap.set('n', '<leader>ni', ':ZkInsertLink<CR>',
                { silent = true, desc = 'Insert link' })
            vim.keymap.set('n', '<leader>nt', ':ZkTags<CR>',
                { silent = true, desc = 'Tags' })
            vim.keymap.set('v', '<leader>nn', ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: ') }<CR>",
                { silent = true, desc = 'New note from selection' })
            vim.keymap.set('v', '<leader>nm', ':ZkMatch<CR>',
                { silent = true, desc = 'Find note from selection' })
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
            local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or 'single'
                opts.max_width = opts.max_width or 60
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end
        end,
        dependencies = { 'neovim/nvim-lspconfig' },
        ft = 'rust',
    },
}
