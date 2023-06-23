local lines_enabled = false
local function on_attach(opts)
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
            },
            { prefix = '<leader>', buffer = bufnr })
        wk.register({
                a = { vim.lsp.buf.code_action, 'Code action' },
                F = { vim.lsp.buf.format, 'Apply formatting' },
            },
            { mode = { 'n', 'v' }, prefix = '<leader>', buffer = bufnr })
        wk.register({
                k = { vim.lsp.buf.signature_help, 'Show signature' },
                r = { vim.lsp.buf.rename, 'Rename symbol' },
                s = { telescope_builtin.lsp_document_symbols, 'Find symbol' },
                S = { telescope_builtin.lsp_workspace_symbols, 'Find workspace symbol' },
            },
            { mode = 'n', prefix = '<leader>', buffer = bufnr })
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
            ['<leader>j'] = { function()
                lines_enabled = not lines_enabled
                vim.diagnostic.config { virtual_lines = lines_enabled, virtual_text = not lines_enabled }
            end, 'Show diagnostic lines' }
        }, { buffer = bufnr })
    end
end

return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'folke/neoconf.nvim', cmd = 'Neoconf', opts = {} },
            { 'folke/neodev.nvim',  opts = {} },                                           -- LSP for neovim config/plugin dev
            'jubnzv/virtual-types.nvim',                                                   -- code lens types
            { 'j-hui/fidget.nvim',                            tag = 'legacy', opts = {} }, -- progress info
            { 'kosayoda/nvim-lightbulb',                      opts = {} },                 -- code action lightbulb
            { 'SmiteshP/nvim-navic',                          opts = {} },                 -- breadcrumbs
            { 'lukas-reineke/lsp-format.nvim',                opts = {} },                 -- auto format
            { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', opts = {} },                 -- diagnostic lines
            'RRethy/vim-illuminate',                                                       -- highlight word under cursor
            {
                'mickael-menu/zk-nvim',
                config = function()
                    require 'zk'.setup()
                end
            },
            'hrsh7th/cmp-nvim-lsp',
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

            require 'nvim-lightbulb'.setup { autocmd = { enabled = true } }
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
                { prefix = '<leader>' })
            wk.register({
                    n = {
                        name = 'Notes',
                        n = { ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: ') }<CR>",
                            'New from selection' },
                        f = { ":'<,'>ZkMatch<CR>", 'Find selection' },
                    },
                },
                { mode = 'v', prefix = '<leader>' })
        end
    },
    {
        'simrat39/rust-tools.nvim', -- Rust-specific plugin
        config = function()
            local capabilities = require 'cmp_nvim_lsp'.default_capabilities()
            require 'rust-tools'.setup {
                tools = {
                    inlay_hints = {
                        highlight = 'NonText',
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
                                x = {
                                    x = { require 'rust-tools'.debuggables.debuggables, 'Debuggables' },
                                },
                            },
                            { prefix = '<leader>', buffer = bufnr })
                    end,
                },
            }
        end,
        dependencies = { 'neovim/nvim-lspconfig' },
    },
}
