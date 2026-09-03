vim.pack.add {
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/akinsho/git-conflict.nvim',
}

require 'gitsigns'.setup {
    sign_priority = 50,
    on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        vim.keymap.set('n', ']h', function() gitsigns.nav_hunk 'next' end, { buffer = bufnr, desc = 'Next hunk' })
        vim.keymap.set('n', '[h', function() gitsigns.nav_hunk 'prev' end, { buffer = bufnr, desc = 'Previous hunk' })
        vim.keymap.set('n', '<leader>b', function() Snacks.git.blame_line() end, { buffer = bufnr, desc = 'Blame' })
        vim.keymap.set('n', '<leader>g', gitsigns.setloclist, { buffer = bufnr, desc = 'File hunks' })
        vim.keymap.set('n', '<leader>G', function() gitsigns.setqflist('all') end, { buffer = bufnr, desc = 'All hunks' })
        vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
        vim.keymap.set('n', '<leader>hd', gitsigns.toggle_deleted, { buffer = bufnr, desc = 'Toggle deleted hunks' })
        vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
        vim.keymap.set('n', '<leader>s', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
        vim.keymap.set('n', '<leader>hv', gitsigns.select_hunk, { buffer = bufnr, desc = 'Select hunk' })
        vim.keymap.set({ 'n', 'v' }, '<leader>y', function() Snacks.gitbrowse() end,
            { buffer = bufnr, desc = 'Open in browser' })
        vim.keymap.set('n', '<leader>X', ':GitConflictListQf<CR>',
            { silent = true, buffer = bufnr, desc = 'Git conflicts' })
        require 'which-key'.add { { '<leader>h', desc = 'Git hunk' }, { '<leader>x', desc = 'Git conflict' } }
        -- Load and refresh git-conflict
        require 'git-conflict'
        vim.cmd 'silent! GitConflictRefresh'
    end
}

require 'git-conflict'.setup {
    default_mappings = {
        ours = '<leader>xo',
        theirs = '<leader>xt',
        none = '<leader>xn',
        both = '<leader>xb',
        next = ']x',
        prev = '[x',
    },
    disable_diagnostics = true,
}
