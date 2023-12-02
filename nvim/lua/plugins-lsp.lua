local lines_enabled = false

local function configure_lsp_lines()
    vim.diagnostic.config { virtual_lines = lines_enabled }
end

local function on_attach(opts)
    vim.diagnostic.config { virtual_text = false }
    local telescope_builtin = require 'telescope.builtin'
    local wk = require 'which-key'
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
        wk.register({
            [']d'] = { vim.diagnostic.goto_next, 'Next diagnostic' },
            ['[d'] = { vim.diagnostic.goto_prev, 'Previous diagnostic' },
        }, { buffer = bufnr })
        wk.register({
                d = { vim.diagnostic.open_float, 'Show this diagnostic' },
                D = { telescope_builtin.diagnostics, 'All diagnostics' },
                h = { vim.lsp.buf.hover, 'Hover' },
                o = { require 'symbols-outline'.toggle_outline, 'Symbol outilne' }
            },
            { prefix = '<localleader>', buffer = bufnr })
        wk.register({
                a = { vim.lsp.buf.code_action, 'Code action' },
                f = { vim.lsp.buf.format, 'Apply formatting' },
            },
            { mode = { 'n', 'v' }, prefix = '<localleader>', buffer = bufnr })
        wk.register({
                k = { vim.lsp.buf.signature_help, 'Show signature' },
                r = { vim.lsp.buf.rename, 'Rename symbol' },
                s = { telescope_builtin.lsp_document_symbols, 'Find symbol' },
                S = { telescope_builtin.lsp_workspace_symbols, 'Find workspace symbol' },
            },
            { mode = 'n', prefix = '<localleader>', buffer = bufnr })
        wk.register({
            g = {
                c = { telescope_builtin.lsp_incoming_calls, 'Caller' },
                C = { telescope_builtin.lsp_outgoing_calls, 'Callee' },
                d = { telescope_builtin.lsp_definitions, 'Definition' },
                D = { vim.lsp.buf.declaration, 'Declaration' },
                t = { telescope_builtin.lsp_type_definitions, 'Type definition' },
                r = { telescope_builtin.lsp_references, 'Reference' },
                i = { telescope_builtin.lsp_implementations, 'Implementation' },
            },
        }, { buffer = bufnr })
        wk.register({
            ['<localleader>j'] = { function()
                lines_enabled = not lines_enabled
                configure_lsp_lines()
            end, 'Show diagnostic lines' }
        }, { buffer = bufnr })
        configure_lsp_lines()
    end
end

return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'folke/neoconf.nvim', cmd = 'Neoconf', opts = {} },
            { 'folke/neodev.nvim',  opts = {} },                           -- LSP for neovim config/plugin dev
            'jubnzv/virtual-types.nvim',                                   -- code lens types
            'kosayoda/nvim-lightbulb',                                     -- code action lightbulb
            { 'SmiteshP/nvim-navic',                          opts = {} }, -- breadcrumbs
            { 'lukas-reineke/lsp-format.nvim',                opts = {} }, -- auto format
            { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', opts = {} }, -- diagnostic lines
            'RRethy/vim-illuminate',                                       -- highlight word under cursor
            {
                'mickael-menu/zk-nvim',
                config = function()
                    require 'zk'.setup()
                end
            },
            'hrsh7th/cmp-nvim-lsp',
            {
                'simrat39/symbols-outline.nvim',
                opts = { autofold_depth = 2 }
            },
            'folke/which-key.nvim',
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
                    require 'which-key'.register({
                        g = {
                            o = { ':ClangdSwitchSourceHeader<CR>', 'Source/header' },
                        },
                    }, { buffer = bufnr })
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

            require('neodev').setup {}

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
            local wk = require 'which-key'
            wk.register({
                    n = {
                        name = 'Notes',
                        n = { ":ZkNew { title = vim.fn.input('Title: ') }<CR>", 'New' },
                        b = { ':ZkBacklinks<CR>', 'Backlinks' },
                        i = { ':ZkInsertLink<CR>', 'Insert link' },
                        f = { ":ZkNotes { sort = { 'modified' } }<CR>", 'Find' },
                        t = { ':ZkTags<CR>', 'Tags' },
                    },
                },
                { prefix = '<localleader>' })
            wk.register({
                    n = {
                        name = 'Notes',
                        n = { ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: ') }<CR>",
                            'New from selection' },
                        f = { ":'<,'>ZkMatch<CR>", 'Find selection' },
                    },
                },
                { mode = 'v', prefix = '<localleader>' })
        end
    },
    {
        'simrat39/rust-tools.nvim', -- Rust-specific plugin
        config = function()
            local capabilities = require 'cmp_nvim_lsp'.default_capabilities()
            require 'rust-tools'.setup {
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
                        require 'which-key'.register({
                                ['<CR>'] = {
                                    ['<CR>'] = { require 'rust-tools'.debuggables.debuggables, 'Debuggables' },
                                },
                            },
                            { prefix = '<localleader>', buffer = bufnr })
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
    },
}
