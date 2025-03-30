-- Git

return {
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            word_diff = true,
            on_attach = function(bufnr)
                local gitsigns = require 'gitsigns'
                vim.keymap.set('n', ']h', gitsigns.next_hunk, { buffer = bufnr, desc = 'Next hunk' })
                vim.keymap.set('n', '[h', gitsigns.prev_hunk, { buffer = bufnr, desc = 'Previous hunk' })
                vim.keymap.set('n', '<leader>b', function() Snacks.git.blame_line() end,
                    { buffer = bufnr, desc = 'Blame' })
                vim.keymap.set('n', '<leader>g', gitsigns.setloclist, { buffer = bufnr, desc = 'File hunks' })
                vim.keymap.set('n', '<leader>G', function() gitsigns.setqflist('all') end,
                    { buffer = bufnr, desc = 'All hunks' })
                vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
                vim.keymap.set('n', '<leader>hd', gitsigns.toggle_deleted,
                    { buffer = bufnr, desc = 'Toggle deleted hunks' })
                vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
                vim.keymap.set('n', '<leader>s', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
                vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
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
        },
    },
    {
        'akinsho/git-conflict.nvim',
        version = "*",
        lazy = true,
        opts = {
            default_mappings = {
                ours = '<leader>xo',
                theirs = '<leader>xt',
                none = '<leader>xn',
                both = '<leader>xb',
                next = ']x',
                prev = '[x',
            },
            disable_diagnostics = true,
        },
    },
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        opts = { styles = { blame_line = { border = 'single' }, }, },
    },
}
