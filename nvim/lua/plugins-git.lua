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
                    vim.keymap.set('n', '=a', gitsigns.blame_line, { buffer = bufnr, desc = 'Blame line' })
                    vim.keymap.set('n', '=c', telescope_builtin.git_bcommits,
                        { buffer = bufnr, desc = 'File commits' })
                    vim.keymap.set('n', '=C', telescope_builtin.git_commits,
                        { buffer = bufnr, desc = 'Directory commits' })
                    vim.keymap.set('n', '=d', gitsigns.toggle_deleted,
                        { buffer = bufnr, desc = 'Toggle deleted hunks' })
                    vim.keymap.set('n', '+', telescope_builtin.git_files, { buffer = bufnr, desc = 'Find file' })
                    vim.keymap.set('n', '==', telescope_builtin.git_status,
                        { buffer = bufnr, desc = 'Status' })
                    vim.keymap.set('n', '=p', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
                    vim.keymap.set('n', '=r', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
                    vim.keymap.set('n', '=h', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
                    vim.keymap.set('n', '=H', gitsigns.undo_stage_hunk,
                        { buffer = bufnr, desc = 'Undo stage hunk' })
                    vim.keymap.set('n', '=v', gitsigns.select_hunk,
                        { buffer = bufnr, desc = 'Select hunk' })
                    vim.keymap.set('v', '=r', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
                    vim.keymap.set('v', '=h', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })

                    vim.keymap.set('n', '=y', function() require 'gitlinker'.get_buf_range_url('n') end,
                        { buffer = bufnr, desc = 'Get link to line' })
                    vim.keymap.set('v', '=y', function() require 'gitlinker'.get_buf_range_url('v') end,
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
