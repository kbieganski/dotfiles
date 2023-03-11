-----------------
--- Debugging ---
-----------------
local M = {}

function M.setup()
    local dap = require 'dap'
    dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb",
    }
    dap.adapters.gdb = {
        type = "executable",
        --command = "/home/krzysztof/binutils-gdb/install/bin/gdb",
        --args = { "-i=dap" },
        command = "bidi-tee",
        args = { "/home/krzysztof/dap-comms.log", "--", "/home/krzysztof/binutils-gdb/install/bin/gdb", "-i=dap" },
        --args = { "/home/krzysztof/dap-comms.log", "--", "/usr/bin/lldb-vscode" },
        name = "gdb",
    }

    --local function get_workspace_root()
    --    return vim.lsp.buf.list_workspace_folders()[1]
    --end

    --local telescope_utils = require 'telescope.utils'
    --local function get_remote_urls()
    --    local remotes = telescope_utils.get_os_command_output { 'git', 'remote' }
    --    if #remotes == 0 then
    --        return nil
    --    end
    --    local urls = {}
    --    for _, remote in ipairs(remotes) do
    --        local url = telescope_utils.get_os_command_output { 'git', 'remote', 'get-url', remote }[1]
    --        urls[#urls + 1] = url
    --    end
    --    return urls
    --end

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
                --local label_fn = function(bin)
                --    return bin --string.format("id=%d name=%s", proc.pid, proc.name)
                --end
                --local co = coroutine.running()
                --if co then
                --    return coroutine.create(function()
                --        local remotes = get_remote_urls()
                --        if not remotes then return nil end
                --        if vim.tbl_contains(remotes, "git@github.com:verilator/verilator.git") then
                --            local bins = {get_workspace_root() .. '/bin/verilator_bin_dbg',get_workspace_root() .. '/bin/verilator_bin_dbg'}
                --            bins = vim.split(vim.fn.glob(get_workspace_root() .. '/test_regress/t/t_*.pl'), '\n')
                --            require'dap.ui'.pick_one(bins, "Select binary", label_fn, function(choice)
                --                coroutine.resume(co, choice and choice.pid or nil)
                --            end)
                --        else
                --            coroutine.resume(co, vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file'))
                --        end
                --    end)
                --else
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                --end
            end,
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

    vim.api.nvim_set_hl(0, 'DapUIVariable', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'DapUIValue', { link = 'Number' })
    vim.api.nvim_set_hl(0, 'DapUIFrameName', { link = 'Type' })
    vim.api.nvim_set_hl(0, 'DapUIThread', { link = 'Function' })
    vim.api.nvim_set_hl(0, 'DapUIWatchesValue', { link = 'DapUIThread' })
    vim.api.nvim_set_hl(0, 'DapUIBreakpointsInfo', { link = 'DapUIThread' })
    vim.api.nvim_set_hl(0, 'DapUIBreakpointsCurrentLine', { link = 'Function' })
    vim.api.nvim_set_hl(0, 'DapUIWatchesEmpty', { link = 'Error' })
    vim.api.nvim_set_hl(0, 'DapUIWatchesError', { link = 'DapUIWatchesEmpty' })
    vim.api.nvim_set_hl(0, 'DapUIBreakpointsDisabledLine', { link= 'Comment' })
    vim.api.nvim_set_hl(0, 'DapUISource', { link = 'Function' })
    vim.api.nvim_set_hl(0, 'DapUIBreakpointsPath', { link = 'String' })
    vim.api.nvim_set_hl(0, 'DapUIScope', { link = 'DapUIBreakpointsPath' })
    vim.api.nvim_set_hl(0, 'DapUILineNumber', { link = 'DapUIBreakpointsPath' })
    vim.api.nvim_set_hl(0, 'DapUIBreakpointsLine', { link = 'DapUIBreakpointsPath' })
    vim.api.nvim_set_hl(0, 'DapUIFloatBorder', { link = 'DapUIBreakpointsPath' })
    vim.api.nvim_set_hl(0, 'DapUIStoppedThread', { link = 'DapUIBreakpointsPath' })
    vim.api.nvim_set_hl(0, 'DapUIDecoration', { link = 'DapUIBreakpointsPath' })
    vim.api.nvim_set_hl(0, 'DapUIModifiedValue', { link = 'Number' })

    require 'nvim-dap-virtual-text'.setup()
end

return M
