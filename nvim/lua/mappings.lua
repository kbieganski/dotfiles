-- Basic mappings
local M = {}

function M.set()
    vim.g.mapleader = ' '

    -- remap Ctrl-C to Esc, so that InsertLeave gets triggered
    vim.keymap.set('n', '<C-c>', '<esc>', { silent = true })

    -- unmap useless stuff
    for _, keys in ipairs({ 'za', 'zA', 'zC', 'ze', 'zH', 'zi', 'zL', 'zm', 'zM', 'zo', 'zO', 'zr', 'zR', 'zs', 'zv', 'zx', 'zf' }) do
        vim.keymap.set('n', keys, function() end, { silent = true, desc = '' })
    end
    for _, keys in ipairs({ '-', '_', '=', '+', 'm' }) do
        vim.keymap.set('n', keys, function() end, { silent = true, desc = '' })
    end

    -- delete without yanking with x/X
    vim.keymap.set('n', 'x', '"_x', { silent = true })
    vim.keymap.set('n', 'X', '"_dd', { silent = true })
    vim.keymap.set('v', 'x', '"_x', { silent = true })
    vim.keymap.set('v', 'X', '"_dd', { silent = true })

    -- replace without yanking the replaced text
    vim.keymap.set('v', 'p', '"_dP', { silent = true })

    -- newline does not switch mode; newline in insert mode
    vim.keymap.set('n', 'o', 'o<esc>kj', { silent = true })
    vim.keymap.set('n', 'O', 'O<esc>jk', { silent = true })
    vim.keymap.set('i', '<M-o>', '<esc>o', { silent = true })
    vim.keymap.set('i', '<M-O>', '<esc>O', { silent = true })

    -- redo on U
    vim.keymap.set('n', 'U', '<C-r><esc>', { silent = true })

    -- move up/down on visual lines
    vim.keymap.set('n', 'j', "v:count ? 'j' : 'gj'", { silent = true, expr = true })
    vim.keymap.set('n', 'k', "v:count ? 'k' : 'gk'", { silent = true, expr = true })

    -- move selected lines up/down
    vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
    vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })

    -- window management with alt
    vim.keymap.set('n', '<M-q>', ':close<CR>', { silent = true })
    vim.keymap.set('n', '<M-c>', ':split<CR>', { silent = true })
    vim.keymap.set('n', '<M-v>', ':vsplit<CR>', { silent = true })
    vim.keymap.set('n', '<M-H>', '<C-w><S-h>', { silent = true })
    vim.keymap.set('n', '<M-J>', '<C-w><S-j>', { silent = true })
    vim.keymap.set('n', '<M-K>', '<C-w><S-k>', { silent = true })
    vim.keymap.set('n', '<M-L>', '<C-w><S-l>', { silent = true })

    -- tab management
    vim.keymap.set('n', '<C-t>', ':tabnew<CR>', { silent = true })
    vim.keymap.set('n', '<C-w>', ':tabclose<CR>', { silent = true })
    vim.keymap.set('n', '<C-tab>', ':tabnext<CR>', { silent = true })
    vim.keymap.set('n', '<C-S-tab>', ':tabprev<CR>', { silent = true })

    -- make < > shifts keep selection
    vim.keymap.set('v', '<', '<gv', { silent = true })
    vim.keymap.set('v', '>', '>gv', { silent = true })


    vim.keymap.set('n', 'Z', ':qa<CR>', { silent = true, desc = 'Quit' })
    vim.keymap.set('n', '<M-Z>', ':qa!<CR>', { silent = true, desc = 'Force quit' })
    vim.keymap.set('n', '<C-s>', ':w<CR>', { silent = true, desc = 'Write current file' })
    vim.keymap.set('n', '<M-s>', ':wa<CR>', { silent = true, desc = 'Write all open files' })
    vim.keymap.set('n', 'zS', ':w !sudo tee %<CR>', { silent = true, desc = 'Write current file (sudo)' })

    vim.keymap.set('n', 'zx', ':bn<CR>:bd#<CR>', { silent = true, desc = 'Close buffer' })
    vim.keymap.set('n', 'zX', ':bn<CR>:bd#!<CR>', { silent = true, desc = 'Force close buffer' })

    -- Rename current file
    vim.keymap.set('n', 'zr', function()
        local filename = vim.api.nvim_buf_get_name(0)
        vim.ui.input({ prompt = 'New filename: ', default = filename, completion = 'file' }, function(new_filename)
            if new_filename == '' then
                return
            end
            if vim.fn.filereadable(filename) == 1 then
                vim.cmd.write(new_filename)
                vim.cmd.bdelete(1)
                vim.cmd.edit(new_filename)
                vim.fn.delete(filename)
            else
                vim.api.nvim_buf_set_name(0, new_filename)
            end
        end)
    end, { silent = true, desc = 'Rename current file' })
end

return M
