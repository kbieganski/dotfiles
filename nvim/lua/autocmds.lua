-- Autocommands
local M = {}

function M.setup()
    -- Check if we need to reload the file when it changed
    vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
        group = vim.api.nvim_create_augroup('checktime', { clear = true }),
        command = 'checktime',
    })

    -- Highlight on yank
    vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
        callback = function()
            -- silent! to workaround bug with virtual text
            vim.cmd('silent! lua vim.highlight.on_yank()')
        end,
    })

    -- resize splits if window got resized
    vim.api.nvim_create_autocmd({ 'VimResized' }, {
        group = vim.api.nvim_create_augroup('resize_splits', { clear = true }),
        callback = function()
            vim.cmd('tabdo wincmd =')
        end,
    })

    -- go to last loc when opening a buffer
    vim.api.nvim_create_autocmd('BufReadPost', {
        group = vim.api.nvim_create_augroup('last_loc', { clear = true }),
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
        group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
        pattern = {
            'PlenaryTestPopup',
            'help',
            'lspinfo',
            'man',
            'notify',
            'qf',
            'query', -- :InspectTree
            'spectre_panel',
            'startuptime',
            'tsplayground',
        },
        callback = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
        end,
    })

    -- wrap and check for spell in text filetypes
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('wrap_spell', { clear = true }),
        pattern = { 'gitcommit', 'markdown' },
        callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
            vim.opt_local.textwidth = 80
        end,
    })

    -- set no statusline on DAP buffers,
    vim.api.nvim_create_autocmd({ 'FileType' },
        {
            group = vim.api.nvim_create_augroup('dapui_no_status', { clear = true }),
            pattern = { 'dapui_watches' },
            callback = function()
                vim.opt_local.laststatus = 0
            end
        })
    vim.api.nvim_create_autocmd({ 'FileType' },
        {
            group = vim.api.nvim_create_augroup('dapui_no_status', { clear = true }),
            pattern = { 'dapui_stacks' },
            callback = function()
                vim.opt_local.laststatus = 0
            end
        })
    vim.api.nvim_create_autocmd({ 'FileType' },
        {
            group = vim.api.nvim_create_augroup('dapui_no_status', { clear = true }),
            pattern = { 'dapui_breakpoints' },
            callback = function()
                vim.opt_local.laststatus = 0
            end
        })
    vim.api.nvim_create_autocmd({ 'FileType' },
        {
            group = vim.api.nvim_create_augroup('dapui_no_status', { clear = true }),
            pattern = { 'dapui_scopes' },
            callback = function()
                vim.opt_local.laststatus = 0
            end
        })
    vim.api.nvim_create_autocmd({ 'FileType' },
        {
            group = vim.api.nvim_create_augroup('dapui_no_status', { clear = true }),
            pattern = { 'dapui_console' },
            callback = function()
                vim.opt_local.laststatus = 0
            end
        })
    vim.api.nvim_create_autocmd({ 'FileType' },
        {
            group = vim.api.nvim_create_augroup('dapui_no_status', { clear = true }),
            pattern = { 'dap-repl' },
            callback = function()
                vim.opt_local.laststatus = 0
            end
        })
end

return M
