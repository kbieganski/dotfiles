-----------------
--- Debugging ---
-----------------
local M = {}

function M.setup(wk)
    local dap = require 'dap'
    wk.register({
                    x = {
                        name = "Debug",
                        b = { dap.toggle_breakpoint, "Breakpoint" },
                        c = { dap.continue, "Continue" },
                        j = { dap.step_into, "Step into" },
                        k = { dap.step_out, "Step out" },
                        l = { dap.step_over, "Step over" },
                    },
                },
                { mode = 'n', prefix = '<leader>' })

    dap.adapters.lldb = {
        type = "executable",
        --command = "lldb-vscode",
        command = "bidi-tee",
        args = { "/home/krzysztof/dap-comms.log", "--", "/usr/bin/lldb-vscode" },
        name = "lldb",
        options={cwd = "/home/krzysztof/verible",}
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

    local telescope_utils = require 'telescope.utils'
    local function get_workspace_root()
        return telescope_utils.get_os_command_output { 'git', 'rev-parse', '--show-toplevel' }[1]
    end

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
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
                local basename = function(path)
                    local segments = vim.split(path, '/')
                    return segments[#segments]
                end
                return coroutine.create(function(co)
                    local remotes = get_remote_urls()
                    if not remotes then return nil end
                    if vim.tbl_contains(remotes, 'git@github.com:antmicro/verible') then
                        local bins = telescope_utils.get_os_command_output { 'find', get_workspace_root() .. '/bazel-bin/verilog/tools', '-executable', '-type', 'f' }
                        vim.ui.select(bins, { prompt = 'Executable', format_item = basename }, function(choice)
                            coroutine.resume(co, choice)
                        end)
                    elseif vim.tbl_contains(remotes, 'git@github.com:verilator/verilator.git') then
                        local tests = vim.split(vim.fn.glob(get_workspace_root() .. '/test_regress/t/t_*.pl'), '\n')
                        vim.ui.select(tests, { prompt = 'Test', format_item = basename }, function(choice)
                            local exec = telescope_utils.get_os_command_output(
                                { 'exex', './driver.pl --debug ' .. choice, 'verilator_bin_dbg' },
                                get_workspace_root() .. '/test_regress')[1]
                            coroutine.resume(co, exec)
                        end)
                    else
                        local bins = telescope_utils.get_os_command_output { 'find', get_workspace_root() .. '/', '-executable', '-type', 'f' }
                        if #bins > 0 then
                            vim.ui.select(bins, { prompt = 'Executable', format_item = basename }, function(choice)
                                coroutine.resume(co, choice)
                            end)
                        else
                        vim.ui.input({ prompt = 'Executable', default = vim.fn.getcwd() .. '/', completion = 'file' }, function(exe)
                            coroutine.resume(co, exe)
                        end)
                        end
                    end
                end)
            end,
            stopOnEntry = true,
            sourceMap = function()
                return {
                    { '/proc/self/cwd/', get_workspace_root() },
                }
            end,
            args = function()
                return coroutine.create(function(co)
                    vim.ui.input({ prompt = 'Args', }, function(args)
                        -- TODO: handle quotes and spaces
                        args = telescope_utils.get_os_command_output { 'zsh', '-c', 'echo ' .. args }[1]
                        vim.notify(args)
                        coroutine.resume(co, {args})
                    end)
                end)
            end,
            cwd = get_workspace_root,
        },
        {
            name = 'Attach',
            type = 'lldb',
            request = 'attach',
            pid = dap_utils.pick_process,
            args = {},
        },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
    local dapui = require 'dapui'
    dapui.setup {
        controls = {
            element = "repl",
            enabled = true,
            icons = {
                disconnect = "⏹️",
                pause = "⏸️",
                play = "▶️",
                run_last = '↺',
                step_back = '↖️',
                step_into = '↘️',
                step_out = '↗️',
                step_over = '↴',
                terminate = '❌'
            }
        },
        expand_lines = false,
        icons = {
            collapsed = "+",
            current_frame = "*",
            expanded = "-"
        },
        layouts = { {
            elements = { {
                id = "scopes",
                size = 0.35
            }, {
                id = "breakpoints",
                size = 0.15
            }, {
                id = "stacks",
                size = 0.35
            }, {
                id = "watches",
                size = 0.15
            } },
            position = "left",
            size = 60
        }, {
            elements = { {
                id = "repl",
                size = 0.5
            }, {
                id = "console",
                size = 0.5
            } },
            position = "bottom",
            size = 10
        } },
    }
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
    vim.fn.sign_define('DapBreakpoint',{ text ='◉'})
    vim.fn.sign_define('DapStopped',{ text ='➤'})
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
