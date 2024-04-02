-- Git

return {
    {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'telescope.nvim', 'ruifm/gitlinker.nvim' },
        config = function()
            local telescope_builtin = require 'telescope.builtin'
            local gitsigns = require 'gitsigns'
            gitsigns.setup {
                numhl = true,
                current_line_blame = false,
                on_attach = function(bufnr)
                    vim.keymap.set('n', ']h', gitsigns.next_hunk, { buffer = bufnr, desc = 'Next hunk' })
                    vim.keymap.set('n', '[h', gitsigns.prev_hunk, { buffer = bufnr, desc = 'Previous hunk' })
                    vim.keymap.set('n', '<leader>b', gitsigns.blame_line, { buffer = bufnr, desc = 'Blame line' })
                    vim.keymap.set('n', '<leader>c', telescope_builtin.git_bcommits,
                        { buffer = bufnr, desc = 'File commits' })
                    vim.keymap.set('n', '<leader>C', telescope_builtin.git_commits,
                        { buffer = bufnr, desc = 'Directory commits' })
                    vim.keymap.set('n', '<leader>d', gitsigns.toggle_deleted,
                        { buffer = bufnr, desc = 'Toggle deleted hunks' })
                    vim.keymap.set('n', '<leader>f', telescope_builtin.git_files, { buffer = bufnr, desc = 'Repo files' })
                    vim.keymap.set('n', '<leader>g', telescope_builtin.git_status,
                        { buffer = bufnr, desc = 'Status' })
                    vim.keymap.set('n', '<leader>p', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
                    vim.keymap.set('n', '<leader>r', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
                    vim.keymap.set('n', '<leader>s', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
                    vim.keymap.set('n', '<leader>S', gitsigns.undo_stage_hunk,
                        { buffer = bufnr, desc = 'Undo stage hunk' })
                    vim.keymap.set('n', '<leader>v', gitsigns.select_hunk,
                        { buffer = bufnr, desc = 'Select hunk' })
                    vim.keymap.set('v', '<leader>r', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
                    vim.keymap.set('v', '<leader>s', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })

                    vim.keymap.set('n', '<leader>y', function() require 'gitlinker'.get_buf_range_url('n') end,
                        { buffer = bufnr, desc = 'Get link to line' })
                    vim.keymap.set('v', '<leader>y', function() require 'gitlinker'.get_buf_range_url('v') end,
                        { buffer = bufnr, desc = 'Get link to line range' })
                end
            }
        end,
    },
    {
        'akinsho/git-conflict.nvim',
        opts = {
            default_mappings = {
                ours = '-o',
                theirs = '-t',
                none = '-n',
                both = '-b',
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
}
