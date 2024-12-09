-- Utility

return {
    {
        'Saecki/crates.nvim',
        event = 'BufRead Cargo.toml',
        opts = {}
    },
    {
        'lewis6991/spaceless.nvim',
        event = 'InsertEnter',
    },
    {
        'NMAC427/guess-indent.nvim',
        event = 'BufReadPre',
        opts = {},
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
            local ori_navigate = tmux_navigator.navigate
            -- Modify Navigator's behavior to not wrap around
            ---@diagnostic disable-next-line: duplicate-set-field
            tmux_navigator.navigate = function(self, direction)
                if pane_at[direction] then
                    ---@diagnostic disable-next-line: invisible
                    self.execute(string.format("if -F '%s' '' 'select-pane -%s'", pane_at[direction],
                        ---@diagnostic disable-next-line: invisible
                        self.direction[direction]))
                    return self
                end
                return ori_navigate(self, direction)
            end
            require 'Navigator'.setup { disable_on_zoom = true, mux = tmux_navigator:new() }
        end,
        keys = {
            { '<M-h>', function() require 'Navigator'.left() end,  desc = 'Window left',  mode = { 'n', 'v', 'i', 't' } },
            { '<M-j>', function() require 'Navigator'.down() end,  desc = 'Window down',  mode = { 'n', 'v', 'i', 't' } },
            { '<M-k>', function() require 'Navigator'.up() end,    desc = 'Window up',    mode = { 'n', 'v', 'i', 't' } },
            { '<M-l>', function() require 'Navigator'.right() end, desc = 'Window right', mode = { 'n', 'v', 'i', 't' } },
        },
    },
    {
        'numToStr/Comment.nvim',
        opts = {},
    },
}
