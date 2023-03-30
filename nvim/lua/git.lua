-----------
--- Git ---
-----------
local M = {}

function M.setup(wk)
    local telescope = require 'telescope'
    local telescope_builtin = require 'telescope.builtin'
    local gitsigns = require 'gitsigns'
    gitsigns.setup {
        numhl = true,
        current_line_blame = false,
        on_attach = function(bufnr)
            wk.register({
                [']h'] = { ':Gitsigns next_hunk<CR>', "Next hunk" },
                ['[h'] = { ':Gitsigns prev_hunk<CR>', "Previous hunk" },
            }, { buffer = bufnr })
            wk.register({
                g = {
                    name = "Git",
                    c = { telescope_builtin.git_bcommits, "Current file history" },
                    C = { telescope_builtin.git_commits, "Repo history" },
                    f = { telescope_builtin.git_files, "Find file" },
                    b = { function() gitsigns.blame_line{ full = true } end, "Blame line" },
                    d = { ':Gitsigns toggle_deleted<CR>', "Toggle deleted hunks" },
                    p = { ':Gitsigns preview_hunk<CR>', "Preview hunk" },
                    r = { ':Gitsigns reset_hunk<CR>', "Reset hunk" },
                    s = { ':Gitsigns stage_hunk<CR>', "Stage hunk" },
                    S = { ':Gitsigns undo_stage_hunk<CR>', "Undo stage hunk" },
                    v = { ':<C-U>Gitsigns select_hunk<CR>', "Select hunk" },
                },
            },
                { prefix = '<leader>', buffer = bufnr })
            -- TODO: fix leader/these mappings in visual mode
            wk.register({
                g = {
                    r = { ':Gitsigns reset_hunk<CR>', "Reset hunk" },
                    s = { ':Gitsigns stage_hunk<CR>', "Stage hunk" },
                },
            },
                {
                    mode = 'v',
                    prefix = '<leader>',
                    buffer = bufnr,
                })
            wk.register({
                G = {
                    name = "GitHub",
                    a = { telescope.extensions.gh.run, "Action runs" },
                    i = { telescope.extensions.gh.issues, "Issues" },
                    p = { telescope.extensions.gh.pull_request, "Pull requests" },
                    x = { telescope.extensions.gh.gist, "Gist" },
                },
            },
                { prefix = '<leader>', buffer = bufnr })
        end
    }

    require 'git-conflict'.setup {
        default_mappings = true,
        disable_diagnostics = true,
        highlights = {
            incoming = "DiffText",
            current = "DiffAdd",
        },
    }

    require 'gitlinker'.setup()
end

return M
