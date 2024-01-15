-- Basic mappings
local M = {}

function M.set()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = '\r'

    -- remap Ctrl-C to Esc, so that InsertLeave gets triggered
    vim.keymap.set('n', '<C-c>', '<esc>', { silent = true })

    -- unmap useless stuff
    vim.keymap.set('n', 'J', function() end, { silent = true })
    vim.keymap.set('n', 'K', function() end, { silent = true })
    vim.keymap.set('n', 's', function() end, { silent = true })

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

    -- window management with the alt and ctrl keys
    vim.keymap.set('n', '<M-q>', ':clo<CR>', { silent = true })
    vim.keymap.set('n', '<M-c>', ':sp<CR>', { silent = true })
    vim.keymap.set('n', '<M-v>', ':vsp<CR>', { silent = true })
    vim.keymap.set('n', '<M-h>', ':NavigatorLeft<CR>', { silent = true })
    vim.keymap.set('n', '<M-j>', ':NavigatorDown<CR>', { silent = true })
    vim.keymap.set('n', '<M-k>', ':NavigatorUp<CR>', { silent = true })
    vim.keymap.set('n', '<M-l>', ':NavigatorRight<CR>', { silent = true })
    vim.keymap.set('n', '<M-H>', '<C-w><S-h>', { silent = true })
    vim.keymap.set('n', '<M-J>', '<C-w><S-j>', { silent = true })
    vim.keymap.set('n', '<M-K>', '<C-w><S-k>', { silent = true })
    vim.keymap.set('n', '<M-L>', '<C-w><S-l>', { silent = true })

    -- tab management
    vim.keymap.set('n', '<C-t>', ':tabnew<CR>', { silent = true })
    vim.keymap.set('n', '<C-w>', ':tabclose<CR>', { silent = true })
    vim.keymap.set('n', '<C-tab>', ':tabnext<CR>', { silent = true })
    vim.keymap.set('n', '<C-S-tab>', ':tabprev<CR>', { silent = true })

    -- faster scrolling
    vim.keymap.set('n', '<C-j>', '2<C-e>2j', { silent = true })
    vim.keymap.set('n', '<C-k>', '2<C-y>2k', { silent = true })

    -- move through jump history
    vim.keymap.set('n', '<C-h>', '<C-o>', { silent = true })
    vim.keymap.set('n', '<C-l>', '<C-i>', { silent = true })

    -- make < > shifts keep selection
    vim.keymap.set('v', '<', '<gv', { silent = true })
    vim.keymap.set('v', '>', '>gv', { silent = true })

    vim.keymap.set('n', '<leader>q', ':qa<CR>', { silent = true, desc = 'Quit' })
    vim.keymap.set('n', '<leader>Q', ':qa!<CR>', { silent = true, desc = 'Force quit' })
    vim.keymap.set('n', '<leader>w', ':w<CR>', { silent = true, desc = 'Write current file' })
    vim.keymap.set('n', '<leader>W', ':w!<CR>', { silent = true, desc = 'Force write current file' })
    vim.keymap.set('n', '<leader><M-w>', ':wa<CR>', { silent = true, desc = 'Write all open files' })
    vim.keymap.set('n', '<leader><C-w>', ':w !sudo tee %<CR>', { silent = true, desc = 'Write current file (sudo)' })
    vim.keymap.set('n', '<leader>bx', ':bn<CR>:bd#<CR>', { silent = true, desc = 'Close buffer' })
    vim.keymap.set('n', '<leader>bX', ':bn<CR>:bd#!<CR>', { silent = true, desc = 'Force close buffer' })

    -- Rename current file
    vim.keymap.set('n', '<leader>R', function()
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
