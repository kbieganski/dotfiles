return {
    {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'telescope.nvim', 'ruifm/gitlinker.nvim' },
        config = function()
            local telescope = require 'telescope'
            local telescope_builtin = require 'telescope.builtin'
            local gitsigns = require 'gitsigns'
            gitsigns.setup {
                numhl = true,
                current_line_blame = false,
                on_attach = function(bufnr)
                    vim.keymap.set('n', ']h', gitsigns.next_hunk, { buffer = bufnr, desc = 'Next hunk' })
                    vim.keymap.set('n', '[h', gitsigns.prev_hunk, { buffer = bufnr, desc = 'Previous hunk' })
                    vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { buffer = bufnr, desc = 'Blame line' })
                    vim.keymap.set('n', '<leader>gc', telescope_builtin.git_bcommits,
                        { buffer = bufnr, desc = 'File commits' })
                    vim.keymap.set('n', '<leader>gd', gitsigns.toggle_deleted,
                        { buffer = bufnr, desc = 'Toggle deleted hunks' })
                    vim.keymap.set('n', '<leader>gf', telescope_builtin.git_files, { buffer = bufnr, desc = 'Find file' })
                    vim.keymap.set('n', '<leader>gh', telescope_builtin.git_status,
                        { buffer = bufnr, desc = 'Repo hunks' })
                    vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
                    vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
                    vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
                    vim.keymap.set('n', '<leader>gS', gitsigns.undo_stage_hunk,
                        { buffer = bufnr, desc = 'Undo stage hunk' })
                    vim.keymap.set('n', '<leader>gv', '<cmd><C-U>Gitsigns select_hunk<CR>',
                        { buffer = bufnr, desc = 'Select hunk' })
                    vim.keymap.set('v', '<leader>gr', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
                    vim.keymap.set('v', '<leader>gs', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })

                    vim.keymap.set('n', '<leader>gy', function() require 'gitlinker'.get_buf_range_url('n') end,
                        { buffer = bufnr, desc = 'Get link to line' })
                    vim.keymap.set('v', '<leader>gy', function() require 'gitlinker'.get_buf_range_url('v') end,
                        { buffer = bufnr, desc = 'Get link to line range' })
                end
            }
        end,
    },
    {
        'akinsho/git-conflict.nvim',
        opts = {
            default_mappings = {
                ours = '<leader>gxo',
                theirs = '<leader>gxt',
                none = '<leader>gxn',
                both = '<leader>gxb',
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
