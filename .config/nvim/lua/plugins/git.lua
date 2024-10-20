-- Git

return {
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            word_diff = true,
            current_line_blame = false,
            on_attach = function(bufnr)
                local gitsigns = require 'gitsigns'
                vim.keymap.set('n', ']h', gitsigns.next_hunk, { buffer = bufnr, desc = 'Next hunk' })
                vim.keymap.set('n', '[h', gitsigns.prev_hunk, { buffer = bufnr, desc = 'Previous hunk' })
                vim.keymap.set('n', '<leader>b', gitsigns.blame_line, { buffer = bufnr, desc = 'Blame line' })
                vim.keymap.set('n', '<leader>h', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
                vim.keymap.set('n', '<leader>H', function() gitsigns.toggle_deleted() end,
                    { buffer = bufnr, desc = 'Toggle deleted hunks' })
                vim.keymap.set('n', '<leader>x', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
                vim.keymap.set('n', '<leader>s', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
                vim.keymap.set('n', '<leader>v', gitsigns.select_hunk,
                    { buffer = bufnr, desc = 'Select hunk' })
                vim.keymap.set('n', '<leader>y', function() require 'gitlinker'.get_buf_range_url('n') end,
                    { buffer = bufnr, desc = 'Get link to line' })
                vim.keymap.set('v', '<leader>y', function() require 'gitlinker'.get_buf_range_url('v') end,
                    { buffer = bufnr, desc = 'Get link to line range' })
                require 'git-conflict' -- Load git-conflict
            end
        },
    },
    {
        'akinsho/git-conflict.nvim',
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
            highlights = {
                incoming = 'DiffText',
                current = 'DiffAdd',
            },
        },
    },
    { 'ruifm/gitlinker.nvim', lazy = true },
}
