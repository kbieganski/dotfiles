-- Utility

return {
    {
        dir = vim.fn.stdpath('config') .. '/dev/compiler-explorer',
    },
    { 'Saecki/crates.nvim', ft = 'toml', opts = {} }, -- cargo file support
    {
        'lewis6991/spaceless.nvim',                   -- trim whitespace
        config = function() require 'spaceless'.setup() end,
    },
    {
        'NMAC427/guess-indent.nvim', -- guess indentation from file
        opts = {},
    },
    {
        'toppair/peek.nvim',
        build = 'deno task --quiet build:fast',
        config = function()
            require 'peek'.setup { theme = 'dark' }
        end,
        keys = {
            {
                '<leader>v',
                function()
                    local peek = require 'peek'
                    if peek.is_open() then
                        peek.close()
                    else
                        vim.fn.system('i3-msg split horizontal')
                        peek.open()
                    end
                end,
                desc = 'Preview'
            },
        },
    },
    {
        'numToStr/Navigator.nvim',
        config = function()
            local pane_at = {
                h = '#{pane_at_left}',
                j = '#{pane_at_bottom}',
                k = '#{pane_at_top}',
                l = '#{pane_at_right}',
            }
            local tmux_navigator = require 'Navigator.mux.tmux'
            tmux_navigator._navigate = tmux_navigator.navigate
            ---@diagnostic disable-next-line: duplicate-set-field
            tmux_navigator.navigate = function(self, direction)
                if pane_at[direction] then
                    ---@diagnostic disable-next-line: invisible
                    self.execute(string.format("if -F '%s' '' 'select-pane -%s'", pane_at[direction],
                        ---@diagnostic disable-next-line: invisible
                        self.direction[direction]))
                else
                    self:_navigate(direction)
                end
                return self
            end
            require 'Navigator'.setup { disable_on_zoom = true, mux = tmux_navigator:new() }
        end,
        keys = {
            { '<M-h>', function() require 'Navigator'.left() end,  desc = 'Window left',  silent = true },
            { '<M-j>', function() require 'Navigator'.down() end,  desc = 'Window down',  silent = true },
            { '<M-k>', function() require 'Navigator'.up() end,    desc = 'Window up',    silent = true },
            { '<M-l>', function() require 'Navigator'.right() end, desc = 'Window right', silent = true },
        },
    },
    {
        'jbyuki/venn.nvim',
        config = function()
            function _G.toggle_venn()
                if not vim.b.venn_enabled then
                    vim.b.venn_enabled = true
                    vim.b.virtualedit_old = vim.opt_local.virtualedit:get()
                    vim.opt_local.virtualedit = 'all'
                    vim.keymap.set('n', 'J', '<C-v>j:VBox<CR>', { buffer = true, silent = true })
                    vim.keymap.set('n', 'K', '<C-v>k:VBox<CR>', { buffer = true, silent = true })
                    vim.keymap.set('n', 'H', '<C-v>h:VBox<CR>', { buffer = true, silent = true })
                    vim.keymap.set('n', 'L', '<C-v>l:VBox<CR>', { buffer = true, silent = true })
                    vim.keymap.set('v', 'f', ':VBox<CR>', { buffer = true, silent = true })
                else
                    vim.b.venn_enabled = false
                    vim.opt_local.virtualedit = vim.b.virtualedit_old
                    vim.keymap.del('n', 'J', { buffer = true })
                    vim.keymap.del('n', 'K', { buffer = true })
                    vim.keymap.del('n', 'H', { buffer = true })
                    vim.keymap.del('n', 'L', { buffer = true })
                    vim.keymap.del('v', 'f', { buffer = true })
                end
            end
        end,
        keys = {
            { '<leader>d', function() toggle_venn() end, desc = 'Toggle diagram drawing', silent = true },
        },
    },
    {
        'numToStr/Comment.nvim',
        opts = {
            toggler = {
                line = 'zcc',
                block = 'zbc',
            },
            opleader = {
                line = 'zc',
                block = 'zb',
            },
            extra = {
                above = 'zcO',
                below = 'zco',
                eol = 'zcA',
            },
        },
    },
}
