-- Git

local function run_cmd(cmd)
    local handle = io.popen('curl -L ' .. vim.fn.shellescape(url) .. ' 2>/dev/null')
    if not handle then return end
    local html = handle:read '*a'
    handle:close()
end

local function git_root()
    local dot_git = vim.fn.finddir('.git', '.;')
    return vim.fn.fnamemodify(dot_git, ':h')
end

local function path_relative_to_git_root()
    local root = git_root()
    if not root then return nil end
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath:sub(1, #root) == root then
        return filepath:sub(#root + 2)
    end
end

local function git_link()
    local path = path_relative_to_git_root()
    if not path then return end
    local _, ls = unpack(vim.fn.getpos 'v')
    local _, le = unpack(vim.fn.getpos '.')
    local lines = ls == le and string.format('#L%d', ls) or string.format('#L%d-L%d', ls, le)
    local remote_branch = vim.system {
        'git', 'rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}' }:wait().stdout
    local remote = string.match(remote_branch, '(.-)/.*')
    local commit = vim.system { 'git', 'rev-parse', 'HEAD' }:wait().stdout
    local remote_url = vim.system { 'git', 'remote', 'get-url', remote }:wait().stdout
    if not remote_url then return end
    remote_url = remote_url:match "^%s*(.-)%s*$"
    if remote_url:sub(#remote_url - 3, #remote_url) == '.git' then
        remote_url = remote_url:sub(1, #remote_url - 4)
    end
    local domain, repo = string.match(remote_url, '^git@(.-):(.*)$')
    if domain and repo then
        return string.format('https://%s/%s/blob/%s/%s%s', domain, repo, commit, path, lines)
    end
    domain, repo = string.match(remote_url, '^https?://(.-)/(.*)$')
    if domain and repo then
        return string.format('https://%s/%s/blob/%s/%s%s', domain, repo, commit, path, lines)
    end
end

local function git_link_to_clipboard()
    local url = git_link()
    if url then
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<Esc>",
                true, false, true), 'n', true)
        vim.fn.setreg('+', url)
        vim.notify('Copied ' .. url .. ' to clipboard')
    else
        vim.notify 'Failed to get git link'
    end
end

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
                vim.keymap.set('n', '<leader>H', gitsigns.toggle_deleted,
                    { buffer = bufnr, desc = 'Toggle deleted hunks' })
                vim.keymap.set('n', '<leader>x', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
                vim.keymap.set('n', '<leader>s', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
                vim.keymap.set('n', '<leader>v', gitsigns.select_hunk, { buffer = bufnr, desc = 'Select hunk' })
                vim.keymap.set('n', '<leader>y', git_link_to_clipboard, { buffer = bufnr, desc = 'Yank link to line' })
                vim.keymap.set('v', '<leader>y', git_link_to_clipboard, { buffer = bufnr, desc = 'Yank link to lines' })
                require 'git-conflict' -- Load git-conflict
            end
        },
    },
    {
        'akinsho/git-conflict.nvim',
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
            highlights = {
                incoming = 'DiffText',
                current = 'DiffAdd',
            },
        },
    },
}
