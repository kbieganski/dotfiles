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
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        config = function()
            Snacks.setup {
                bigfile = { enabled = true },
                image = { enabled = true, doc = { inline = false } },
                input = { enabled = true },
                notifier = {
                    enabled = true, style = 'minimal', top_down = false,
                    margin = { top = 1, bottom = 1 },
                },
                picker = { enabled = true,
                    layout = { layout = { box = 'horizontal', min_width = 80,
                        width = 0.75, height = 0.5, border = 'single',
                        { box = 'vertical',
                            { win = 'list', }, { win = 'input', height = 1, border = 'top' }, },
                        { win = 'preview', title = '{preview}', border = 'left', width = 0.5 },
                    } },
                    previewers = {
                        diff = { builtin = false, cmd = { 'delta', '--file-style=omit' }, },
                    }
                },
                quickfile = { enabled = true },
                scope = { enabled = true },
                scroll = {
                    enabled = true,
                    animate = { duration = { step = 10, total = 200 }, },
                    animate_repeat = { delay = 100, duration = { step = 2, total = 40 }, },
                },
                statuscolumn = { enabled = true },
                styles = {
                    blame_line = { border = 'single' },
                    input = { border = 'single' },
                    scratch = { border = 'single' },
                    snacks_image = { border = 'single' },
                },
            }
            vim.api.nvim_create_autocmd('LspProgress', {
                callback = function(ev)
                    local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
                    vim.notify(vim.lsp.status(), 'info', {
                        id = 'lsp_progress',
                        title = 'LSP Progress',
                        opts = function(notif)
                            notif.icon = ev.data.params.value.kind == 'end' and '✓'
                                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                        end,
                    })
                end,
            })
            -- FIXME: scratch does not play well with rustaceanvim
        end,
        keys = {
            { '<leader>u', function() Snacks.picker.undo() end,    desc = 'Undo tree' },
            { "<leader>'", function() Snacks.scratch() end,        desc = 'Toggle scratch' },
            { '<leader>"', function() Snacks.scratch.select() end, desc = 'Select scratch' },
        }
    },
}
