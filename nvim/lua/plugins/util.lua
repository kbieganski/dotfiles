-- Utility

return {
    {
        dir = vim.fn.stdpath('config') .. '/dev/compiler-explorer',
    },
    { 'Saecki/crates.nvim', ft = 'toml', opts = {} },
    {
        'lewis6991/spaceless.nvim',
        config = function() require 'spaceless'.setup() end,
    },
    {
        'NMAC427/guess-indent.nvim',
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
                '<leader><CR>',
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
        filetype = { 'markdown' },
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
            tmux_navigator.navigate = function(self, direction)
                if pane_at[direction] then
                    self.execute(string.format("if -F '%s' '' 'select-pane -%s'", pane_at[direction],
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
