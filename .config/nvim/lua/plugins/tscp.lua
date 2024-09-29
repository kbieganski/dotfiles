-- Telescope

-- Get the current selection in visual mode
local function get_visual_selection()
    if vim.api.nvim_get_mode().mode ~= 'v' then
        return ''
    else
        local _, ls, cs = unpack(vim.fn.getpos('v'))
        local _, le, ce = unpack(vim.fn.getpos('.'))
        ls = ls - 1; le = le - 1; cs = cs - 1
        local lines = vim.api.nvim_buf_get_text(0, math.min(ls, le),
            math.min(cs, ce), math.max(ls, le), math.max(cs, ce), {})
        return table.concat(lines, ' ')
    end
end

-- Open a finder from the current finder
local function open_using_finder(finder)
    local action_state = require 'telescope.actions.state'
    return function(prompt_bufnr)
        local entry_path = action_state.get_selected_entry().Path
        local path = entry_path:is_dir() and entry_path:absolute() or entry_path:parent():absolute()
        require 'telescope.actions'.close(prompt_bufnr)
        finder({ cwd = path })
    end
end

return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        config = function()
            require 'telescope'.setup {
                defaults = {
                    prompt_prefix = '❯ ',
                    selection_caret = '⏵ ',
                    borderchars = {
                        prompt = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                        results = { ' ', ' ', '─', ' ', ' ', ' ', ' ', ' ' },
                        preview = { ' ', ' ', '─', ' ', ' ', ' ', ' ', ' ' },
                    },
                    path_display = 'truncate',
                    layout_strategy = 'vertical',
                    layout_config = {
                        flex = { flip_columns = 180 },
                        vertical = { width = { padding = 0 }, height = { padding = 0 } },
                        horizontal = { width = { padding = 0 }, height = { padding = 0 } },
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
                    file_browser = {
                        hijack_netrw = true,
                        mappings = {
                            i = {
                                ['\\'] = open_using_finder(require 'telescope.builtin'.live_grep),
                                ['|'] = open_using_finder(require 'telescope.builtin'.find_files),
                            },
                        },
                    },
                }
            }
            require 'telescope'.load_extension 'fzf'
            require 'telescope'.load_extension 'file_browser'
        end,
        keys = {
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
                '\\',
                function()
                    local selection = get_visual_selection()
                    require 'telescope.builtin'.live_grep({ default_text = selection })
                end,
                mode = { 'n', 'v' },
                desc = 'Find in files'
            },
            {
                '+',
                function() require 'telescope.builtin'.buffers { ignore_current_buffer = true, sort_mru = true } end,
                desc = 'Switch buffer'
            },
            { '<leader>h', function() require 'telescope.builtin'.help_tags() end, desc = 'Help' },
            { '<leader>l', function() require 'telescope.builtin'.resume() end,    desc = 'Last picker' },
            { '<M-p>',     function() require 'telescope.builtin'.registers() end, desc = 'Paste' },
            { '<leader>o', function() require 'telescope.builtin'.oldfiles() end,  desc = 'Recent files' },
            {
                '|',
                function() require 'telescope.builtin'.find_files { hidden = true, follow = true } end,
                desc = 'Find file'
            },
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build =
                'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
            },
            {
                'nvim-telescope/telescope-file-browser.nvim',
                keys = {
                    {
                        '<leader>f',
                        function() require 'telescope'.extensions.file_browser.file_browser { respect_gitignore = false } end,
                        desc = 'Browse files'
                    },
                },
            },
        },
    },
    {
        'debugloop/telescope-undo.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
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
            require 'telescope'.setup { extensions = { undo = { mappings = { i = { ['<CR>'] = require 'telescope-undo.actions'.restore } } } } }
            require 'telescope'.load_extension 'undo'
        end,
    },
}
