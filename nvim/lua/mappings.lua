-- Basic mappings
local M = {}

function M.set()
    -- delete without yanking with x/X
    vim.cmd [[nnoremap x "_x]]
    vim.cmd [[nnoremap X "_dd]]
    vim.cmd [[vnoremap x "_x]]
    vim.cmd [[vnoremap X "_dd]]

    -- replace without yanking the replaced text
    vim.cmd [[vnoremap p pgvy]]

    -- newline in insert mode
    vim.cmd [[nnoremap <M-o> o<esc>k]]
    vim.cmd [[nnoremap <M-O> O<esc>j]]

    -- redo on U
    vim.cmd [[nnoremap U <C-r><esc>]]

    -- move up/down on visual lines
    vim.cmd [[noremap <expr> j v:count ? 'j' : 'gj']]
    vim.cmd [[noremap <expr> k v:count ? 'k' : 'gk']]

    -- move selected lines up/down
    vim.cmd [[vnoremap J :m '>+1<CR>gv=gv]]
    vim.cmd [[vnoremap K :m '<-2<CR>gv=gv]]

    -- window managment with the alt and ctrl keys
    vim.cmd [[nnoremap <M-q> <C-w>q]]
    vim.cmd [[nnoremap <M-c> <C-w>s]]
    vim.cmd [[nnoremap <M-v> <C-w>v]]
    vim.cmd [[nnoremap <M-h> :NavigatorLeft<CR>]]
    vim.cmd [[nnoremap <M-j> :NavigatorDown<CR>]]
    vim.cmd [[nnoremap <M-k> :NavigatorUp<CR>]]
    vim.cmd [[nnoremap <M-l> :NavigatorRight<CR>]]
    vim.cmd [[nnoremap <M-H> <C-w><S-h>]]
    vim.cmd [[nnoremap <M-J> <C-w><S-j>]]
    vim.cmd [[nnoremap <M-K> <C-w><S-k>]]
    vim.cmd [[nnoremap <M-L> <C-w><S-l>]]

    -- faster scrolling
    vim.cmd [[nnoremap J 2j2<C-e>]]
    vim.cmd [[nnoremap K 2k2<C-y>]]

    -- move through jump history
    vim.cmd [[noremap H <C-o>]]
    vim.cmd [[noremap L <C-i>]]

    -- make < > shifts keep selection
    vim.cmd [[vnoremap < <gv]]
    vim.cmd [[vnoremap > >gv]]
end

return M
