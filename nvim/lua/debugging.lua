-----------------
--- Debugging ---
-----------------
local M = {}

function M.setup(wk)
    local dap = require 'dap'
    dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb",
    }

    local function get_workspace_root()
        return vim.lsp.buf.list_workspace_folders()[1]
    end

    local telescope_utils = require 'telescope.utils'
    local function get_remote_urls()
        local remotes = telescope_utils.get_os_command_output { 'git', 'remote' }
        if #remotes == 0 then
            return nil
        end
        local urls = {}
        for _, remote in ipairs(remotes) do
            local url = telescope_utils.get_os_command_output { 'git', 'remote', 'get-url', remote }[1]
            urls[#urls + 1] = url
        end
        return urls
    end

    local dap_utils = require 'dap.utils'
    dap.configurations.cpp = {
        {
            name = 'Attach',
            type = 'lldb',
            request = 'attach',
            pid = dap_utils.pick_process,
            args = {},
        },
        {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
                local remotes = get_remote_urls()
                if not remotes then return nil end
                if vim.tbl_contains(remotes, "git@github.com:verilator/verilator.git") then
                    return get_workspace_root() .. '/bin/verilator_bin_dbg'
                else
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = true,
            args = {},
        },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
    local dapui = require 'dapui'
    dapui.setup {}
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    require 'nvim-dap-virtual-text'.setup()
end

return M
