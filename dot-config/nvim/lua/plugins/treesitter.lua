-- Tree-sitter

local filetypes = { 'bash', 'c', 'cpp', 'css', 'glsl', 'go', 'html', 'javascript', 'json', 'lua',
    'markdown', 'python', 'query', 'regex', 'rust', 'typescript', 'verilog', 'yaml', 'zig' }
local langs = vim.fn.extend(filetypes, { 'comment', 'markdown_inline' })

local textobjects = {
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
            gsb = { query = '@block.outer', desc = 'a block' },
            gsf = { query = '@function.outer', desc = 'a function' },
            gsi = { query = '@conditional.inner', desc = 'a conditional' },
            gsp = { query = '@parameter.inner', desc = 'a parameter' },
            gss = { query = '@statement.outer', desc = 'a statement' },
            gst = { query = '@class.outer', desc = 'a class' },
        },
        swap_previous = {
            gSb = { query = '@block.outer', desc = 'a block' },
            gSf = { query = '@function.outer', desc = 'a function' },
            gSi = { query = '@conditional.inner', desc = 'a conditional' },
            gSp = { query = '@parameter.inner', desc = 'a parameter' },
            gSs = { query = '@statement.outer', desc = 'a statement' },
            gSt = { query = '@class.outer', desc = 'a class' },
        },
    },
    select = {
        enable = true,
        lookahead = true,
        keymaps = {
            ab = { query = '@block.outer', desc = 'a block' },
            ac = { query = '@call.outer', desc = 'a call' },
            af = { query = '@function.outer', desc = 'a function' },
            at = { query = '@class.outer', desc = 'a class' },
            ib = { query = '@block.inner', desc = 'a block' },
            ic = { query = '@call.inner', desc = 'a call' },
            ['if'] = { query = '@function.inner', desc = 'a function' },
            it = { query = '@class.inner', desc = 'a class' },
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
            for _, ft in ipairs(filetypes) do
                vim.api.nvim_create_autocmd('FileType', {
                    pattern = ft,
                    callback = function()
                        local win = vim.api.nvim_get_current_win()
                        vim.wo[win][0].foldmethod = 'expr'
                        vim.wo[win][0].foldexpr = 'nvim_treesitter#foldexpr()'
                    end
                })
            end
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
        ft = filetypes,
    },
}
