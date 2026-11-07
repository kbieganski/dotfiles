vim.pack.add {
    'https://github.com/Saecki/crates.nvim',
    'https://github.com/lewis6991/spaceless.nvim',
    'https://github.com/NMAC427/guess-indent.nvim',
    'https://github.com/numToStr/Navigator.nvim',
}

-- crates.nvim
require 'crates'.setup {}

-- guess-indent.nvim
require 'guess-indent'.setup {}

-- Navigator.nvim
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
local navigator = require 'Navigator'
local ok, tmux = pcall(function() return tmux_navigator:new() end)
navigator.setup { disable_on_zoom = true, mux = ok and tmux or 'auto' }
vim.keymap.set({ 'n', 'v', 'i', 't' }, '<M-h>', function() navigator.left() end, { desc = 'Window left' })
vim.keymap.set({ 'n', 'v', 'i', 't' }, '<M-j>', function() navigator.down() end, { desc = 'Window down' })
vim.keymap.set({ 'n', 'v', 'i', 't' }, '<M-k>', function() navigator.up() end, { desc = 'Window up' })
vim.keymap.set({ 'n', 'v', 'i', 't' }, '<M-l>', function() navigator.right() end,
    { desc = 'Window right' })
