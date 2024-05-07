-- Tree-sitter

local langs = { 'bash', 'c', 'c_sharp', 'cpp', 'css', 'glsl', 'go', 'haskell', 'javascript', 'lua', 'markdown',
    'markdown_inline', 'nix', 'python', 'query', 'regex', 'rust', 'typescript', 'verilog', 'zig' }

return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'v0.9.2',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = langs,
                highlight = { enable = true },
                textobjects = {
                    lsp_interop = {
                        enable = true,
                        border = 'none',
                        peek_definition_code = {
                            ['<M-K>'] = '@*.outer',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
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
                            gsa = '@assignment.inner',
                            gsb = '@block.outer',
                            gsc = '@class.outer',
                            gsf = '@function.outer',
                            gsi = '@conditional.inner',
                            gsp = '@parameter.inner',
                            gss = '@statement.outer',
                        },
                        swap_previous = {
                            gSa = '@assignment.inner',
                            gSb = '@block.outer',
                            gSc = '@class.outer',
                            gSf = '@function.outer',
                            gSi = '@conditional.inner',
                            gSp = '@parameter.inner',
                            gSs = '@statement.outer',
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
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        ft = langs,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
            max_lines = 1,
            mode = 'topline',
        },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        ft = langs,
    },
    {
        'kylechui/nvim-surround',
        opts = {},
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-treesitter/nvim-treesitter-textobjects' },
        ft = langs,
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        ft = langs,
    }
}
