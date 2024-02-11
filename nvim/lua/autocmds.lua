-- Autocommands
local M = {}

function M.setup()
    -- Check if we need to reload the file when it changed
    vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
        group = vim.api.nvim_create_augroup('checktime', {}),
        command = 'checktime',
    })

    -- Highlight on yank
    vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('highlight_yank', {}),
        callback = vim.highlight.on_yank,
    })

    -- resize splits if window got resized
    vim.api.nvim_create_autocmd('VimResized', {
        group = vim.api.nvim_create_augroup('resize_splits', {}),
        callback = function()
            vim.cmd [[tabdo wincmd =]]
        end,
    })

    -- go to last loc when opening a buffer
    vim.api.nvim_create_autocmd('BufReadPost', {
        group = vim.api.nvim_create_augroup('last_loc', {}),
        callback = function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end,
    })

    -- close some filetypes with <q>
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('close_with_q', {}),
        pattern = {
            'PlenaryTestPopup',
            'help',
            'lspinfo',
            'man',
            'notify',
            'qf',
            'query', -- :InspectTree
            'startuptime',
            'tsplayground',
        },
        callback = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
        end,
    })

    vim.api.nvim_create_autocmd('FileType',
        {
            group = vim.api.nvim_create_augroup('markdown_link_mapping', {}),
            pattern = 'markdown',
            callback = function(e)
                vim.keymap.set('n', '<leader>l', function()
                        local url = vim.fn.getreg "+"
                        if url == "" then return end
                        local cmd = "curl -L " .. vim.fn.shellescape(url) .. " 2>/dev/null"
                        local handle = io.popen(cmd)
                        if not handle then return end
                        local html = handle:read "*a"
                        handle:close()
                        local title = ""
                        local pattern = "<title>(.-)</title>"
                        local m = string.match(html, pattern)
                        if m then title = m end
                        if title ~= "" then
                            local pos = vim.api.nvim_win_get_cursor(0)[2]
                            local line = vim.api.nvim_get_current_line()
                            local link = "[" .. title .. "](" .. url .. ")"
                            local new_line = line:sub(0, pos) .. link .. line:sub(pos + 1)
                            vim.api.nvim_set_current_line(new_line)
                        else
                            vim.notify("Title not found for link")
                        end
                    end,
                    { buffer = e.buf, silent = true, desc = 'Paste link' })
                vim.opt_local.laststatus = 0
            end
        })

    -- set no statusline on DAP buffers,
    local dapui_no_status_group = vim.api.nvim_create_augroup('dapui_no_status', {})
    for _, pattern in ipairs({ 'dapui_watches', 'dapui_stacks', 'dapui_breakpoints', 'dapui_scopes', 'dapui_console', 'dap-repl' }) do
        vim.api.nvim_create_autocmd('FileType',
            {
                group = dapui_no_status_group,
                pattern = pattern,
                callback = function(e)
                    vim.opt_local.laststatus = 0
                end
            })
    end
end

return M
