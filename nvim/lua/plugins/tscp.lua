-- Telescope

local function get_visual_selection()
    if vim.api.nvim_get_mode().mode ~= 'v' then
        return ''
    else
        local _, ls, cs = unpack(vim.fn.getpos('v'))
        local _, le, ce = unpack(vim.fn.getpos('.'))
        ls = ls - 1; le = le - 1; cs = cs - 1; ce = ce - 1
        local lines = vim.api.nvim_buf_get_text(0, math.min(ls, le), math.min(cs, ce), math.max(ls, le), math.max(cs, ce),
            {})
        return table.concat(lines, ' ')
    end
end

return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local telescope = require 'telescope'
            telescope.setup {
                defaults = {
                    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    layout_strategy = 'flex',
                    layout_config = {
                        flex = { flip_columns = 240 },
                        vertical = { width = 0.9, height = 0.9 },
                        horizontal = { width = 0.9, height = 0.9 },
                    },
                    mappings = {
                        i = {
                            ['<ESC>'] = 'close',
                            ['<down>'] = 'move_selection_next',
                            ['<M-j>'] = 'move_selection_next',
                            ['<up>'] = 'move_selection_previous',
                            ['<M-k>'] = 'move_selection_previous',
                        },
                    },
                    file_ignore_patterns = { '.cache', '.clangd' },
                },
                extensions = {
                    hijack_netrw = true,
                },
            }
        end,
        keys = {
            {
                '<M-`>',
                function() require 'telescope.builtin'.jumplist() end,
                desc = 'Jumps'
            },
            {
                '<M-/>',
                function()
                    local selection = get_visual_selection()
                    require 'telescope.builtin'.current_buffer_fuzzy_find({ default_text = selection })
                end,
                mode = { 'n', 'v' },
                desc = 'Find in current file'
            },
            {
                '<M-\\>',
                function()
                    local selection = get_visual_selection()
                    require 'telescope.builtin'.live_grep({ default_text = selection })
                end,
                mode = { 'n', 'v' },
                desc = 'Find in files'
            },
            {
                '<leader>b',
                function() require 'telescope.builtin'.buffers { ignore_current_buffer = true, sort_mru = true } end,
                desc = 'Switch buffer'
            },
            { '<leader>h',       function() require 'telescope.builtin'.help_tags() end, desc = 'Help' },
            { '<leader><Space>', function() require 'telescope.builtin'.resume() end,    desc = 'Last picker' },
            { '<M-p>',           function() require 'telescope.builtin'.registers() end, desc = 'Paste' },
            { '`',               function() require 'telescope.builtin'.oldfiles() end,  desc = 'Recent files' },
            {
                '|',
                function() require 'telescope.builtin'.find_files { hidden = true, follow = true } end,
                desc = 'Find file'
            },
        },
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
        config = function()
            require 'telescope'.load_extension 'file_browser'
        end,
        keys = {
            {
                '\\',
                function() require 'telescope'.extensions.file_browser.file_browser { respect_gitignore = false } end,
                desc = 'Browse files'
            },
        },
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function()
            require 'telescope'.load_extension 'fzf'
        end,
    },
    {
        'nvim-telescope/telescope-github.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
        config = function()
            require 'telescope'.load_extension 'gh'
        end,
        keys = {
            { '<leader>a', function() require 'telescope'.extensions.gh.run() end,          desc = 'GH Action runs' },
            { '<leader>g', function() require 'telescope'.extensions.gh.gist() end,         desc = 'GH Gists' },
            { '<leader>i', function() require 'telescope'.extensions.gh.issues() end,       desc = 'GH issues' },
            { '<leader>p', function() require 'telescope'.extensions.gh.pull_request() end, desc = 'GH pull requests' },
        },
    },
    {
        'cljoly/telescope-repo.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
        config = function()
            require 'telescope'.load_extension 'repo'
        end,
        keys = {
            { '<leader>r', function() require 'telescope'.extensions.repo.repo() end, desc = 'Repositories' },
        },
    },
    {
        'debugloop/telescope-undo.nvim',
        dependencies = { -- note how they're inverted to above example
            {
                'nvim-telescope/telescope.nvim',
                dependencies = { 'nvim-lua/plenary.nvim' },
            },
        },
        keys = {
            {
                '<M-u>',
                function() require 'telescope'.extensions.undo.undo() end,
                desc = 'undo history',
            },
        },
        opts = {},
        config = function()
            require 'telescope'.load_extension('undo')
        end,
    },
}
