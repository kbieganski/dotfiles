vim.pack.add {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    'https://github.com/kylechui/nvim-surround',
}

local filetypes = { 'bash', 'c', 'cpp', 'css', 'gdscript', 'gdshader', 'glsl', 'go', 'godot_resource',
    'html', 'javascript', 'json', 'lua', 'markdown', 'python', 'query', 'regex', 'rust', 'typescript',
    'systemverilog', 'yaml', 'zig' }
local langs = vim.fn.extend(filetypes, { 'comment', 'markdown_inline' })

require 'nvim-treesitter'.install(langs)

require 'nvim-treesitter-textobjects'.setup {
    move = {
        set_jumps = true,
    },
    select = {
        lookahead = true,
        selection_modes = {
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
        },
    },
}

local select = require 'nvim-treesitter-textobjects.select'

vim.keymap.set({ 'x', 'o' }, 'ab',
    function() select.select_textobject('@block.outer', 'textobjects') end, { desc = 'a block' })
vim.keymap.set({ 'x', 'o' }, 'ac',
    function() select.select_textobject('@call.outer', 'textobjects') end, { desc = 'a call' })
vim.keymap.set({ 'x', 'o' }, 'af',
    function() select.select_textobject('@function.outer', 'textobjects') end, { desc = 'a function' })
vim.keymap.set({ 'x', 'o' }, 'at',
    function() select.select_textobject('@class.outer', 'textobjects') end, { desc = 'a type' })
vim.keymap.set({ 'x', 'o' }, 'ib',
    function() select.select_textobject('@block.inner', 'textobjects') end, { desc = 'a block' })
vim.keymap.set({ 'x', 'o' }, 'ic',
    function() select.select_textobject('@call.inner', 'textobjects') end, { desc = 'a call' })
vim.keymap.set({ 'x', 'o' }, 'if',
    function() select.select_textobject('@function.inner', 'textobjects') end, { desc = 'a function' })
vim.keymap.set({ 'x', 'o' }, 'it',
    function() select.select_textobject('@class.inner', 'textobjects') end, { desc = 'a type' })

local move = require 'nvim-treesitter-textobjects.move'

vim.keymap.set({ 'n', 'x', 'o' }, ']a',
    function() move.goto_next_start('@assignment.outer', 'textobjects') end, { desc = 'Next assignment' })
vim.keymap.set({ 'n', 'x', 'o' }, ']b',
    function() move.goto_next_start('@block.outer', 'textobjects') end, { desc = 'Next block' })
vim.keymap.set({ 'n', 'x', 'o' }, ']c',
    function() move.goto_next_start('@call.outer', 'textobjects') end, { desc = 'Next call' })
vim.keymap.set({ 'n', 'x', 'o' }, ']f',
    function() move.goto_next_start('@function.outer', 'textobjects') end, { desc = 'Next function' })
vim.keymap.set({ 'n', 'x', 'o' }, ']i',
    function() move.goto_next_start('@conditional.outer', 'textobjects') end, { desc = 'Next if/loop' })
vim.keymap.set({ 'n', 'x', 'o' }, ']p',
    function() move.goto_next_start('@parameter.inner', 'textobjects') end, { desc = 'Next parameter' })
vim.keymap.set({ 'n', 'x', 'o' }, ']r',
    function() move.goto_next_start('@return.inner', 'textobjects') end, { desc = 'Next return' })
vim.keymap.set({ 'n', 'x', 'o' }, ']t',
    function() move.goto_next_start('@class.outer', 'textobjects') end, { desc = 'Next type' })

vim.keymap.set({ 'n', 'x', 'o' }, ']A',
    function() move.goto_next_end('@assignment.outer', 'textobjects') end, { desc = 'Next assignment end' })
vim.keymap.set({ 'n', 'x', 'o' }, ']B',
    function() move.goto_next_end('@block.outer', 'textobjects') end, { desc = 'Next block end' })
vim.keymap.set({ 'n', 'x', 'o' }, ']C',
    function() move.goto_next_end('@call.outer', 'textobjects') end, { desc = 'Next call end' })
vim.keymap.set({ 'n', 'x', 'o' }, ']F',
    function() move.goto_next_end('@function.outer', 'textobjects') end, { desc = 'Next function end' })
vim.keymap.set({ 'n', 'x', 'o' }, ']I',
    function() move.goto_next_end('@conditional.outer', 'textobjects') end, { desc = 'Next if/loop end' })
vim.keymap.set({ 'n', 'x', 'o' }, ']P',
    function() move.goto_next_end('@parameter.inner', 'textobjects') end, { desc = 'Next parameter end' })
vim.keymap.set({ 'n', 'x', 'o' }, ']R',
    function() move.goto_next_end('@return.inner', 'textobjects') end, { desc = 'Next return end' })
vim.keymap.set({ 'n', 'x', 'o' }, ']T',
    function() move.goto_next_end('@class.outer', 'textobjects') end, { desc = 'Next type end' })

vim.keymap.set({ 'n', 'x', 'o' }, '[a',
    function() move.goto_previous_start('@assignment.outer', 'textobjects') end, { desc = 'Prev assignment' })
vim.keymap.set({ 'n', 'x', 'o' }, '[b',
    function() move.goto_previous_start('@block.outer', 'textobjects') end, { desc = 'Prev block' })
vim.keymap.set({ 'n', 'x', 'o' }, '[c',
    function() move.goto_previous_start('@call.outer', 'textobjects') end, { desc = 'Prev call' })
vim.keymap.set({ 'n', 'x', 'o' }, '[f',
    function() move.goto_previous_start('@function.outer', 'textobjects') end, { desc = 'Prev function' })
vim.keymap.set({ 'n', 'x', 'o' }, '[i',
    function() move.goto_previous_start('@conditional.outer', 'textobjects') end, { desc = 'Prev if/loop' })
vim.keymap.set({ 'n', 'x', 'o' }, '[p',
    function() move.goto_previous_start('@parameter.inner', 'textobjects') end, { desc = 'Prev parameter' })
vim.keymap.set({ 'n', 'x', 'o' }, '[r',
    function() move.goto_previous_start('@return.inner', 'textobjects') end, { desc = 'Prev return' })
vim.keymap.set({ 'n', 'x', 'o' }, '[t',
    function() move.goto_previous_start('@class.outer', 'textobjects') end, { desc = 'Prev type' })

vim.keymap.set({ 'n', 'x', 'o' }, '[A',
    function() move.goto_previous_end('@assignment.outer', 'textobjects') end, { desc = 'Prev assignment end' })
vim.keymap.set({ 'n', 'x', 'o' }, '[B',
    function() move.goto_previous_end('@block.outer', 'textobjects') end, { desc = 'Prev block end' })
vim.keymap.set({ 'n', 'x', 'o' }, '[C',
    function() move.goto_previous_end('@call.outer', 'textobjects') end, { desc = 'Prev call end' })
vim.keymap.set({ 'n', 'x', 'o' }, '[F',
    function() move.goto_previous_end('@function.outer', 'textobjects') end, { desc = 'Prev function end' })
vim.keymap.set({ 'n', 'x', 'o' }, '[I',
    function() move.goto_previous_end('@conditional.outer', 'textobjects') end, { desc = 'Prev if/loop end' })
vim.keymap.set({ 'n', 'x', 'o' }, '[P',
    function() move.goto_previous_end('@parameter.inner', 'textobjects') end, { desc = 'Prev parameter end' })
vim.keymap.set({ 'n', 'x', 'o' }, '[R',
    function() move.goto_previous_end('@return.inner', 'textobjects') end, { desc = 'Prev return end' })
vim.keymap.set({ 'n', 'x', 'o' }, '[T',
    function() move.goto_previous_end('@class.outer', 'textobjects') end, { desc = 'Prev type end' })

local swap = require 'nvim-treesitter-textobjects.swap'

vim.keymap.set('n', 'gsb',
    function() swap.swap_next('@block.outer', 'textobjects') end, { desc = 'a block' })
vim.keymap.set('n', 'gsf',
    function() swap.swap_next('@function.outer', 'textobjects') end, { desc = 'a function' })
vim.keymap.set('n', 'gsi',
    function() swap.swap_next('@conditional.outer', 'textobjects') end, { desc = 'an if/loop' })
vim.keymap.set('n', 'gsp',
    function() swap.swap_next('@parameter.inner', 'textobjects') end, { desc = 'a parameter' })
vim.keymap.set('n', 'gss',
    function() swap.swap_next('@statement.outer', 'textobjects') end, { desc = 'a statement' })
vim.keymap.set('n', 'gst',
    function() swap.swap_next('@class.outer', 'textobjects') end, { desc = 'a type' })
vim.keymap.set('n', 'gst',
    function() swap.swap_next('@class.inner', 'textobjects') end, { desc = 'a type' })

vim.keymap.set('n', 'gSb',
    function() swap.swap_previous('@block.outer', 'textobjects') end, { desc = 'a block' })
vim.keymap.set('n', 'gSf',
    function() swap.swap_previous('@function.outer', 'textobjects') end, { desc = 'a function' })
vim.keymap.set('n', 'gSi',
    function() swap.swap_previous('@conditional.outer', 'textobjects') end, { desc = 'an if/loop' })
vim.keymap.set('n', 'gSp',
    function() swap.swap_previous('@parameter.inner', 'textobjects') end, { desc = 'a parameter' })
vim.keymap.set('n', 'gSs',
    function() swap.swap_previous('@statement.outer', 'textobjects') end, { desc = 'a statement' })
vim.keymap.set('n', 'gSt',
    function() swap.swap_previous('@class.outer', 'textobjects') end, { desc = 'a type' })
vim.keymap.set('n', 'gSt',
    function() swap.swap_previous('@class.inner', 'textobjects') end, { desc = 'a type' })

require 'nvim-surround'.setup {}

for _, ft in ipairs(filetypes) do
    vim.api.nvim_create_autocmd('FileType', {
        pattern = ft,
        callback = function()
            vim.treesitter.start()
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldmethod = 'expr'
            vim.wo[win][0].foldexpr = 'nvim_treesitter#foldexpr()'
        end
    })
end
