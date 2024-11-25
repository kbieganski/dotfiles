-- Tree-sitter

local langs = { 'bash', 'c', 'cpp', 'css', 'glsl', 'go', 'haskell', 'html', 'javascript', 'json', 'lua', 'markdown',
    'markdown_inline', 'python', 'query', 'regex', 'rust', 'typescript', 'verilog', 'yaml', 'zig' }

local textobjects = {
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
            [']a'] = { query = { '@assignment.outer' }, desc = 'Next assignment' },
            [']b'] = { query = { '@block.inner', 'block.outer' }, desc = 'Next block' },
            [']c'] = { query = { '@call.outer' }, desc = 'Next call' },
            [']f'] = { query = { '@function.outer' }, desc = 'Next function' },
            [']i'] = { query = { '@conditional.outer', '@loop.outer' }, desc = 'Next conditional or loop' },
            [']p'] = { query = { '@parameter.inner' }, desc = 'Next parameter' },
            [']r'] = { query = { '@return.inner' }, desc = 'Next return' },
            [']t'] = { query = { '@class.outer' }, desc = 'Next type' },
        },
        goto_next_end = {
            [']A'] = { query = { '@assignment.outer' }, desc = 'Next assignment end' },
            [']B'] = { query = { '@block.inner', 'block.outer' }, desc = 'Next block end' },
            [']C'] = { query = { '@call.outer' }, desc = 'Next call end' },
            [']F'] = { query = { '@function.outer' }, desc = 'Next function end' },
            [']I'] = { query = { '@conditional.outer', '@loop.outer' }, desc = 'Next conditional end' },
            [']P'] = { query = { '@parameter.inner' }, desc = 'Next parameter end' },
            [']R'] = { query = { '@return.inner' }, desc = 'Next return end' },
            [']T'] = { query = { '@class.outer' }, desc = 'Next type end' },
        },
        goto_previous_start = {
            ['[a'] = { query = { '@assignment.outer' }, desc = 'Previous assignment' },
            ['[b'] = { query = { '@block.inner', 'block.outer' }, desc = 'Previous block' },
            ['[c'] = { query = { '@call.outer' }, desc = 'Previous call' },
            ['[f'] = { query = { '@function.outer' }, desc = 'Previous function' },
            ['[i'] = { query = { '@conditional.outer', '@loop.outer' }, desc = 'Previous conditional' },
            ['[p'] = { query = { '@parameter.inner' }, desc = 'Previous parameter' },
            ['[r'] = { query = { '@return.inner' }, desc = 'Previous return' },
            ['[t'] = { query = { '@class.outer' }, desc = 'Previous type' },
        },
        goto_previous_end = {
            ['[A'] = { query = { '@assignment.outer' }, desc = 'Previous assignment end' },
            ['[B'] = { query = { '@block.inner', 'block.outer' }, desc = 'Previous block end' },
            ['[C'] = { query = { '@call.outer' }, desc = 'Previous call end' },
            ['[I'] = { query = { '@conditional.outer', '@loop.outer' }, desc = 'Previous conditional end' },
            ['[F'] = { query = { '@function.outer' }, desc = 'Previous function end' },
            ['[P'] = { query = { '@parameter.inner' }, desc = 'Previous parameter end' },
            ['[R'] = { query = { '@return.inner' }, desc = 'Previous return end' },
            ['[T'] = { query = { '@class.outer' }, desc = 'Previous type end' },
        },
    },
    swap = {
        enable = true,
        swap_next = {
            gsa = '@assignment.outer',
            gsb = '@block.outer',
            gsc = '@class.outer',
            gsf = '@function.outer',
            gsi = '@conditional.inner',
            gsp = '@parameter.inner',
            gss = '@statement.outer',
        },
        swap_previous = {
            gSa = '@assignment.outer',
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
}

return {
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = langs,
                highlight        = { enable = true },
                textobjects      = textobjects,
            }
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
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
