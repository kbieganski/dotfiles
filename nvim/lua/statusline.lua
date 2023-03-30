------------------
--- Statusline ---
------------------

local M = {}

function M.setup()
    require 'lualine'.setup {
        options = {
            disabled_filetypes = {
                statusline = { 'Outline', 'dapui_watches', 'dapui_stacks', 'dapui_breakpoints', 'dapui_scopes', 'dapui_console', 'dap-repl' },
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff" },
            lualine_c = { "filename", { "diagnostics", sources = { "nvim_diagnostic" } } },
            lualine_x = { "filetype" },
            lualine_y = { "encoding", "fileformat" },
            lualine_z = { "progress", "location" },
        },
    }
end

return M
