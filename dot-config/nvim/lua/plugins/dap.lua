local function visualize(opts)
    opts = opts or {}
    local varname = opts.varname or vim.fn.expand("<cexpr>")
    local session = require("dap").session() or {}
    local scopes = (session.current_frame or {}).scopes
    local variable = nil
    for _, scope in ipairs(scopes or {}) do
        for _, v in ipairs(scope.variables) do
            if v.name == varname then
                variable = v
                break
            end
        end
    end
    if not variable then
        vim.notify("Variable not found:" .. varname, "error")
        return
    end
    variable = variable --[[@as dap.Variable]]
    local f = assert(io.open("/tmp/dap.gv", "w"), "Must be able to open file")
    coroutine.wrap(function()
        f:write("digraph G {\n")
        f:write("  graph [\n")
        f:write("     layout=dot\n")
        f:write("     labelloc=t\n")
        f:write("  ]\n")

        -- -@param v dap.Variable
        -- -@return dap.Variable[]
        local function get_children(v)
            if v.variablesReference == 0 then
                return {}
            end
            local params = {
                variablesReference = v.variablesReference
            }
            local err, result = session:request("variables", params)
            assert(not err, err and require("dap.utils").fmt_error(err))
            return result.variables
        end

        ---@param v dap.Variable
        ---@return dap.Variable
        local function resolve_lazy(v)
            if (v.presentationHint or {}).lazy then
                local resolved = get_children(v)[1]
                resolved.name = v.name
                return resolved
            end
            return v
        end

        local function sanitize_html(text)
            text = text:gsub('[<>&"]', { ["<"] = "&lt;", [">"] = "&gt;", ["&"] = "&amp;", ['"'] = '&quot;' })
            return text
        end

        ---@param parent dap.Variable
        local function add_children(parent, parent_name, depth)
            if depth == 0 then return end
            local children = get_children(parent)
            parent_name = parent_name or parent.name
            local property_values = {}
            for _, var in ipairs(children) do
                if var.variablesReference > 0 then
                    for _, child_var in ipairs(get_children(var)) do
                        table.insert(property_values, var.name .. ": " .. sanitize_html(resolve_lazy(child_var).value))
                    end
                else
                    table.insert(property_values, sanitize_html(var.value))
                end
            end
            for _, var in pairs(children) do
                local name = parent_name .. "." .. var.name
                var = resolve_lazy(var)
                if var.value ~= "" then
                    f:write(string.format(
                        '  "%s" [label=<<b>%s</b><br/>%s>]\n',
                        name,
                        name,
                        table.concat(property_values, "<br/>")))
                else
                    f:write(string.format('  "%s"\n', name))
                end
                f:write(string.format('  "%s" -> "%s"\n', parent_name, name))
                f:flush()
                add_children(var, name, depth - 1)
            end
        end

        variable = resolve_lazy(variable)
        if variable then
            f:write(string.format('  "%s"\n', variable.name))
            add_children(variable, variable.name, 4)
        else
            vim.notify("Variable could not be resovled:" .. varname, "error")
        end
        f:write("}")
        f:close()
        vim.fn.system("dot -Txlib /tmp/dap.gv")
    end)()
end

local function setup()
    local dap = require('dap')
    vim.fn.sign_define('DapBreakpoint', { text = ' ', texthl = 'Special', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = ' ', texthl = 'Special', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = ' ', texthl = 'Special', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '󰜴 ', texthl = 'Special', linehl = 'LspReferenceText', numhl = 'Special' })
    vim.fn.sign_define('DapBreakpointRejected', { text = ' ', texthl = 'Special', linehl = '', numhl = '' })

    vim.api.nvim_create_autocmd("WinEnter", {
        callback = function()
            local win = vim.api.nvim_get_current_win()
            local value = (
                (vim.bo.buftype == "" and package.loaded.dap and require("dap").session())
                and "yes:1"
                or "auto"
            )
            vim.wo[win].signcolumn = value
        end,
    })
    vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("dap", { clear = true }),
        pattern = "DapProgressUpdate",
        command = "redrawstatus"
    })

    local widgets = require('dap.ui.widgets')
    local keymap = vim.keymap
    local function set(mode, lhs, rhs)
        keymap.set(mode, lhs, rhs, { silent = true })
    end
    set({ 'n', 't' }, '<leader><leader>q', function()
        dap.terminate({ hierarchy = true })
    end)
    set({ 'n', 't' }, '<leader><leader>c', dap.continue)
    set('n', '<leader><leader>b', dap.toggle_breakpoint)
    set('n', '<leader><leader>B', function()
        local condition = vim.fn.input({ prompt = 'Breakpoint condition: ' })
        if condition and condition ~= "" then
            dap.toggle_breakpoint(condition, nil, nil, true)
        end
    end)
    set('n', '<leader><leader>lp', function()
        local logpoint = vim.fn.input({ prompt = 'Logpoint message: ' })
        if logpoint then
            dap.toggle_breakpoint(nil, nil, logpoint, true)
        end
    end)
    set('n', '<leader><leader>lv', function()
        local variable = vim.fn.expand("<cexpr>")
        local logpoint = string.format("%s={%s}", variable, variable)
        if logpoint then
            dap.toggle_breakpoint(nil, nil, logpoint, true)
        end
    end)
    set('n', '<leader><leader>dr', function() dap.repl.toggle({ height = 15 }) end)
    set('n', '<leader><leader>dR', dap.restart_frame)
    set('n', '<leader><leader>dl', function()
        if vim.bo.modified and vim.bo.buftype == '' then
            vim.cmd.w()
        end
        dap.run_last()
    end)
    set({ "n", "x" }, "<leader><leader>de", "<cmd>DapEval | setlocal winfixheight<cr>")
    set('n', '<leader><leader>j', dap.down)
    set('n', '<leader><leader>k', dap.up)
    set('n', '<leader><leader>C', dap.run_to_cursor)
    set('n', '<leader><leader>g', dap.goto_)
    set('n', '<leader><leader>x', function() widgets.centered_float(widgets.expression) end)
    set('n', '<leader><leader>f', function() widgets.centered_float(widgets.frames) end)
    set('n', '<leader><leader>t', function() widgets.centered_float(widgets.threads) end)
    set('n', '<leader><leader>s', function() widgets.centered_float(widgets.scopes) end)
    set({ 'n', 'v' }, '<leader><leader>h', widgets.hover)
    set({ 'n', 'v' }, '<leader><leader>p', function()
        widgets.preview(nil, { listener = { "event_stopped" } })
    end)
    set("n", "<leader><leader>i", function()
        dap.repl.open()
        dap.repl.execute(vim.fn.expand("<cexpr>"))
    end)
    set("x", "<leader><leader>i", function()
        local lines = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))
        dap.repl.open()
        dap.repl.execute(table.concat(lines, "\n"))
    end)

    dap.listeners.after.event_initialized["compl-triggers"] = function(session)
        local capabilities = session.capabilities
        if capabilities then
            capabilities.completionTriggerCharacters = { "a", "e", "i", "o", "u", "." }
        end
    end

    dap.listeners.after.event_initialized['me.dap'] = function()
        set("n", "<up>", dap.step_back)
        set("n", "<down>", dap.step_over)
        set("n", "<left>", dap.step_out)
        set("n", "<right>", dap.step_into)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.bo[api.nvim_win_get_buf(win)].buftype == "" then
                vim.wo[win].signcolumn = "yes:1"
            end
        end
    end
    local after_session = function()
        if not next(dap.sessions()) then
            pcall(keymap.del, "n", "<up>")
            pcall(keymap.del, "n", "<down>")
            pcall(keymap.del, "n", "<left>")
            pcall(keymap.del, "n", "<right>")
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                vim.wo[win].signcolumn = "auto"
            end
        end
    end
    dap.listeners.after.event_terminated['me.dap'] = after_session
    dap.listeners.after.disconnect['me.dap'] = after_session
    dap.listeners.after.disconnect['me.dap'] = after_session
    dap.listeners.after.event_stopped['me.dap'] = function(session, _)
        if not session.current_frame then return end -- No current frame at first stop
        vim.cmd.edit(session.current_frame.source.path)
        vim.fn.cursor(session.current_frame.line + 1, vim.fn.getcurpos()[5])
    end

    local sidebar = widgets.sidebar(widgets.scopes)
    local create_command = vim.api.nvim_create_user_command
    create_command('DapSidebar', sidebar.toggle, { nargs = 0 })
    create_command('DapBreakpoints', function() dap.list_breakpoints(true) end, { nargs = 0 })
    create_command('DapVisualize', function() visualize() end, { nargs = 0 })

    create_command("DapDiff", function(cmd_args)
        local fargs = cmd_args.fargs
        local max_level = nil
        if #fargs == 3 then
            max_level = tonumber(fargs[3])
        elseif #fargs ~= 2 then
            error("Two or three arguments required")
        end
        require("dap.ui.widgets").diff_var(fargs[1], fargs[2], max_level)
    end, { nargs = "+" })

    local sessions_bar = widgets.sidebar(widgets.sessions, {}, '5 sp | setlocal winfixheight')
    create_command("DapSessions", sessions_bar.toggle, { nargs = 0 })

    dap.defaults.fallback.switchbuf = 'usevisible,usetab,uselast'
    dap.defaults.fallback.terminal_win_cmd = function(config)
        local oldwin = vim.api.nvim_get_current_win()

        ---@diagnostic disable-next-line: undefined-field
        local module = config.module
        ---@diagnostic disable-next-line: undefined-field
        local args = config.args or {}

        if config.type == "python"
            and (module == "unittest" or (module == "django" and args[1] == "test")) then
            vim.cmd("belowright new")
        else
            vim.cmd.tabnew()
        end
        local path = vim.bo.path
        local bufnr = vim.api.nvim_get_current_buf()
        vim.bo[bufnr].path = path
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(oldwin)
        return bufnr, win
    end

    dap.defaults.fallback.external_terminal = {
        command = 'kitty',
        args = { '--single-instance' },
    }
    dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-q", "-i", "dap" }
    }
    dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-dap',
        name = "lldb"
    }

    ---@type dap.ExecutableAdapter
    local function program()
        local path = vim.fn.input({
            prompt = 'Path to executable: ',
            default = vim.fn.getcwd() .. '/',
            completion = 'file'
        })
        return (path and path ~= "") and path or dap.ABORT
    end


    local lldb_setup = {
        {
            text =
            'command script import "/home/krzysztof/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/etc/lldb_lookup.py"'
        }, {
        text =
        'command source -s 0 "/home/krzysztof/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/etc/lldb_commands"'
    },
    }

    -- Dont forget, attach needs permission:
    --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    local configs = {
        {
            name = "gdb: Launch",
            type = "gdb",
            request = "launch",
            program = "${command:pickFile}",
            cwd = '${workspaceFolder}',
        },
        {
            name = "gdb: Attach to process",
            type = 'gdb',
            request = 'attach',
            pid = require('dap.utils').pick_process,
            args = {},
        },
        {
            name = "gdbserver: attach",
            type = "gdb",
            request = "attach",
            target = function() return tonumber(vim.fn.input({ prompt = 'Address: ' })) end,
            cwd = '${workspaceFolder}',
        },
        {
            name = "lldb: Launch (integratedTerminal)",
            type = "lldb",
            request = "launch",
            program = program,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
            runInTerminal = true,
            setupCommands = lldb_setup,
        },
        {
            name = "lldb: Launch (console)",
            type = "lldb",
            request = "launch",
            program = program,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
            runInTerminal = false,
            setupCommands = lldb_setup,
        },
        {
            name = "lldb: Attach to process",
            type = 'lldb',
            request = 'attach',
            pid = require('dap.utils').pick_process,
            args = {},
            setupCommands = lldb_setup,
        },
    }
    dap.configurations.c = configs
    dap.configurations.cpp = configs
    dap.configurations.rust = configs
    dap.configurations.zig = configs
end

return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            setup()
            -- local dap = require 'dap'
            -- dap.adapters.lldb = {
            --     type = 'executable',
            --     command = 'lldb-dap',
            --     name = 'lldb',
            -- }
            --
            -- local dap_utils = require 'dap.utils'
            -- dap.configurations.cpp = {
            --     {
            --         name = 'Launch',
            --         type = 'lldb',
            --         request = 'launch',
            --         program = function()
            --             local basename = function(path)
            --                 local segments = vim.split(path, '/')
            --                 return segments[#segments]
            --             end
            --             return coroutine.create(function(co)
            --                 local bins = 0
            --                 -- local bins = telescope_utils.get_os_command_output { 'find', get_workspace_root() .. '/',
            --                 -- '-executable', '-type', 'f' }
            --                 if #bins > 0 then
            --                     vim.ui.select(bins, { prompt = 'Executable', format_item = basename },
            --                         function(choice)
            --                             coroutine.resume(co, choice)
            --                         end)
            --                 else
            --                     vim.ui.input(
            --                         { prompt = 'Executable', default = vim.fn.getcwd() .. '/', completion = 'file' },
            --                         function(exe)
            --                             coroutine.resume(co, exe)
            --                         end)
            --                 end
            --             end)
            --         end,
            --         stopOnEntry = true,
            --         sourceMap = function()
            --             return {
            --                 { '/proc/self/cwd/', get_workspace_root() },
            --             }
            --         end,
            --         args = function()
            --             return coroutine.create(function(co)
            --                 vim.ui.input({ prompt = 'Args', }, function(args)
            --                     -- TODO: handle quotes and spaces
            --                     args = telescope_utils.get_os_command_output { 'zsh', '-c', 'echo ' .. args }[1]
            --                     vim.notify(args)
            --                     coroutine.resume(co, { args })
            --                 end)
            --             end)
            --         end,
            --         cwd = get_workspace_root,
            --     },
            --     {
            --         name = 'Attach',
            --         type = 'lldb',
            --         request = 'attach',
            --         pid = dap_utils.pick_process,
            --         args = {},
            --     },
            -- }
            --
            -- dap.configurations.cpp = {
            --     {
            --         name = 'Launch',
            --         type = 'lldb',
            --         request = 'launch',
            --         program = function()
            --             return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            --         end,
            --         cwd = '${workspaceFolder}',
            --         stopOnEntry = true,
            --         args = {},
            --     },
            -- }
            --
            -- dap.configurations.c = dap.configurations.cpp
            -- dap.configurations.rust = dap.configurations.cpp

            -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
            -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
            -- dap.listeners.before.event_exited['dapui_config'] = dapui.close
        end,
    },
}
