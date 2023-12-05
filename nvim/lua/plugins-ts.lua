LANGS = { 'bash', 'c', 'cpp', 'css', 'glsl', 'go', 'haskell', 'javascript', 'lua', 'markdown', 'python', 'query',
    'regex', 'rust', 'typescript', 'verilog', 'zig' }
-- Tree-sitter plugins
return {
    {
        'nvim-treesitter/nvim-treesitter',
        ft = LANGS,
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = LANGS,
                highlight = { enable = true },
            }
        end,
        build = ':TSUpdate',
    },
    {
        "kylechui/nvim-surround",
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-treesitter/nvim-treesitter-textobjects' },
        ft = LANGS,
        opts = {},
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        ft = LANGS,
        config = function()
            require 'nvim-treesitter.configs'.setup {
                textobjects = {
                    lsp_interop = {
                        enable = true,
                        border = 'single',
                        peek_definition_code = {
                            ['<localleader>H'] = '@*.outer',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']a'] = { query = { '@assignment.inner' }, },
                            [']b'] = { query = { '@block.inner' }, },
                            [']c'] = { query = { '@class.outer' }, desc = 'Next class' },
                            [']f'] = { query = { '@function.outer' }, desc = 'Next function' },
                            [']i'] = { query = { '@conditional.outer', '@loop.outer' }, },
                            [']p'] = { query = { '@parameter.inner' }, },
                            [']s'] = { query = { '@statement.outer' }, },
                            [']t'] = { query = { '@*.inner' }, },
                        },
                        goto_next_end = {
                            [']C'] = { query = { '@class.outer' }, desc = 'Next class end' },
                            [']F'] = { query = { '@function.outer' }, desc = 'Next function end' },
                            [']M'] = { query = { '@function.outer', '@class.outer' }, desc = 'Next class or function' },
                            [']B'] = { query = { '@block.inner' }, },
                            [']A'] = { query = { '@assignment.inner' }, },
                            [']P'] = { query = { '@parameter.inner' }, },
                            [']I'] = { query = { '@conditional.outer', '@loop.outer' }, },
                            [']T'] = { query = { '@*.inner' }, },
                        },
                        goto_previous_start = {
                            ['[c'] = { query = { '@class.outer' }, desc = 'Previous class' },
                            ['[f'] = { query = { '@function.outer' }, desc = 'Previous function' },
                            ['[b'] = { query = { '@block.inner' }, },
                            ['[a'] = { query = { '@assignment.inner' }, },
                            ['[p'] = { query = { '@parameter.inner' }, },
                            ['[i'] = { query = { '@conditional.outer', '@loop.outer' }, },
                            ['[s'] = { query = { '@statement.outer' }, },
                            ['[t'] = { query = { '@.*.inner' }, },
                        },
                        goto_previous_end = {
                            ['[C'] = { query = { '@class.outer' }, desc = 'Previous class end' },
                            ['[F'] = { query = { '@function.outer' }, desc = 'Previous function end' },
                            ['[M'] = { query = { '@function.outer', '@class.outer' }, desc =
                            'Previous class or function (end)' },
                            ['[B'] = { query = { '@block.inner' }, },
                            ['[A'] = { query = { '@assignment.inner' }, },
                            ['[P'] = { query = { '@parameter.inner' }, },
                            ['[I'] = { query = { '@conditional.outer', '@loop.outer' }, },
                            ['[T'] = { query = { '@.*.inner' }, },
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            sa = '@assignment.inner',
                            sb = '@block.outer',
                            sc = '@class.outer',
                            sf = '@function.outer',
                            si = '@conditional.inner',
                            sp = '@parameter.inner',
                            ss = '@statement.outer',
                        },
                        swap_previous = {
                            Sa = '@assignment.inner',
                            Sb = '@block.outer',
                            Sc = '@class.outer',
                            Sf = '@function.outer',
                            Si = '@conditional.inner',
                            Sp = '@parameter.inner',
                            Ss = '@statement.outer',
                        },
                    },
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            af = '@function.outer',
                            ab = '@block.outer',
                            ac = '@class.outer',
                            am = { query = { '@function.outer', '@class.outer' }, desc = 'a class or function' },
                            ['if'] = '@function.inner',
                            ib = { query = '@block.inner', desc = 'a block' },
                            ic = { query = '@class.inner', desc = 'a class' },
                            im = { query = { '@function.inner', '@class.inner' }, desc = 'a class or function' },
                            as = '@statement.inner',
                            aS = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
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
        'kevinhwang91/nvim-ufo',
        dependencies = { 'kevinhwang91/promise-async', 'nvim-treesitter/nvim-treesitter' },
        ft = LANGS,
        config = function()
            require 'ufo'.setup {
                provider_selector = function()
                    return { 'treesitter', 'indent' }
                end
            }
        end,
    }
}
