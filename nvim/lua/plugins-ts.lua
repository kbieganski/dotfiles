-- Tree-sitter plugins
return {
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = {
                    'bash',
                    'c',
                    'cpp',
                    'css',
                    'glsl',
                    'go',
                    'haskell',
                    'html',
                    'javascript',
                    'lua',
                    'python',
                    'query',
                    'regex',
                    'rust',
                    'typescript',
                    'zig',
                },
                highlight = { enable = true },
            }
        end,
        build = ':TSUpdate',
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require 'nvim-treesitter.configs'.setup {
                textobjects = {
                    lsp_interop = {
                        enable = true,
                        border = 'single',
                        peek_definition_code = {
                            ["<leader>h"] = "@*.outer",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = { query = { "@function.outer", "@class.outer" }, desc = "Next class or function" },
                            ["]b"] = { query = { "@block.inner" }, },
                            ["]c"] = { query = { "@call.inner" }, },
                            ["]a"] = { query = { "@assignment.inner" }, },
                            ["]p"] = { query = { "@parameter.inner" }, },
                            ["]i"] = { query = { "@conditional.outer", "@loop.outer" }, },
                            ["]s"] = { query = { "@statement.outer" }, },
                            ["]t"] = { query = { "@*.inner" }, },
                        },
                        goto_next_end = {
                            ["]M"] = { query = { "@function.outer", "@class.outer" }, desc = "Next class or function" },
                            ["]B"] = { query = { "@block.inner" }, },
                            ["]C"] = { query = { "@call.inner" }, },
                            ["]A"] = { query = { "@assignment.inner" }, },
                            ["]P"] = { query = { "@parameter.inner" }, },
                            ["]I"] = { query = { "@conditional.outer", "@loop.outer" }, },
                            ["]T"] = { query = { "@*.inner" }, },
                        },
                        goto_previous_start = {
                            ["[m"] = { query = { "@function.outer", "@class.outer" }, desc = "Previous class or function" },
                            ["[b"] = { query = { "@block.inner" }, },
                            ["[c"] = { query = { "@call.inner" }, },
                            ["[a"] = { query = { "@assignment.inner" }, },
                            ["[p"] = { query = { "@parameter.inner" }, },
                            ["[i"] = { query = { "@conditional.outer", "@loop.outer" }, },
                            ["[s"] = { query = { "@statement.outer" }, },
                            ["[t"] = { query = { "@.*.inner" }, },
                        },
                        goto_previous_end = {
                            ["[M"] = { query = { "@function.outer", "@class.outer" }, desc =
                            "Previous class or function (end)" },
                            ["[B"] = { query = { "@block.inner" }, },
                            ["[C"] = { query = { "@call.inner" }, },
                            ["[A"] = { query = { "@assignment.inner" }, },
                            ["[P"] = { query = { "@parameter.inner" }, },
                            ["[I"] = { query = { "@conditional.outer", "@loop.outer" }, },
                            ["[T"] = { query = { "@.*.inner" }, },
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["ss"] = "@statement.outer",
                            ["sp"] = "@parameter.inner",
                            ["si"] = "@conditional.inner",
                            ["sm"] = { query = { "@function.outer", "@class.outer" } },
                        },
                        swap_previous = {
                            ["Ss"] = "@statement.outer",
                            ["Sp"] = "@parameter.inner",
                            ["Si"] = "@conditional.inner",
                            ["Sm"] = { query = { "@function.outer", "@class.outer" } },
                        },
                    },
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["ab"] = "@block.outer",
                            ["ac"] = "@class.outer",
                            ["am"] = { query = { "@function.outer", "@class.outer" }, desc = "a class or function" },
                            ["if"] = "@function.inner",
                            ["ib"] = { query = "@block.inner", desc = "a block" },
                            ["ic"] = { query = "@class.inner", desc = "a class" },
                            ["im"] = { query = { "@function.inner", "@class.inner" }, desc = "a class or function" },
                            ["as"] = "@statement.inner",
                            ["aS"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                        },
                        selection_modes = {
                            ['@function.outer'] = 'V',
                            ['@class.outer'] = 'V',
                        },
                    },
                },
            }
        end
    },
    {
        'nvim-treesitter/playground',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
}
