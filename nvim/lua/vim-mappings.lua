--------------------------
--- Vim-style mappings ---
--------------------------
local M = {}

function M.set()
    -- browse headings
    vim.cmd.nnoremap 'gh :Telescope heading<CR>'

    -- use system clilpbard by default
    vim.cmd.nnoremap 'y "+y'
    vim.cmd.nnoremap 'yy "+yy'
    vim.cmd.nnoremap 'p "+p'
    vim.cmd.nnoremap 'P "+P'
    vim.cmd.nnoremap 'd "+d'
    vim.cmd.nnoremap 'dd "+dd'
    vim.cmd.nnoremap 'x "_x'
    vim.cmd.nnoremap 'X "_dd'

    -- use system clilpboard by default, and
    -- replace currently selected text with default register
    -- without yanking it
    vim.cmd.vnoremap 'y "+ygv'
    vim.cmd.vnoremap 'p "_d"+P'
    vim.cmd.vnoremap 'P "_d"+P'
    vim.cmd.vnoremap 'd "+d'
    vim.cmd.vnoremap 'x "_x'
    vim.cmd.vnoremap 'X "_x'

    -- do not insert on o/O
    vim.cmd.nnoremap 'o o<esc>'
    vim.cmd.nnoremap 'O O<esc>'

    -- redo on U
    vim.cmd.nnoremap 'U <C-r><esc>'

    -- move up/down on visual lines
    vim.cmd.nnoremap "<expr> j v:count ? 'j' : 'gj'"
    vim.cmd.nnoremap "<expr> k v:count ? 'k' : 'gk'"

    -- window managment with the alt key
    vim.cmd.nnoremap '<M-q> <C-w>q'
    vim.cmd.nnoremap '<M-c> <C-w>s'
    vim.cmd.nnoremap '<M-v> <C-w>v'
    vim.cmd.nnoremap '<M-h> <C-w>h'
    vim.cmd.nnoremap '<M-j> <C-w>j'
    vim.cmd.nnoremap '<M-k> <C-w>k'
    vim.cmd.nnoremap '<M-l> <C-w>l'
    vim.cmd.nnoremap '<M-S-h> <C-w><S-h>'
    vim.cmd.nnoremap '<M-S-j> <C-w><S-j>'
    vim.cmd.nnoremap '<M-S-k> <C-w><S-k>'
    vim.cmd.nnoremap '<M-S-l> <C-w><S-l>'

    -- faster scrolling
    vim.cmd.noremap 'J <C-e><C-e>'
    vim.cmd.noremap 'K <C-y><C-y>'

    -- move through jump history
    vim.cmd.noremap 'H <C-o>'
    vim.cmd.noremap 'L <C-i>'

    -- make < > shifts keep selection
    vim.cmd.vnoremap '< <gv'
    vim.cmd.vnoremap '> >gv'

    -- snippet navigation ---
    vim.cmd.imap "<expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'"
    vim.cmd.smap "<expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'"
    vim.cmd.imap "<expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'"
    vim.cmd.smap "<expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'"
    vim.cmd.imap "<expr> <M-l>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<M-l>'"
    vim.cmd.smap "<expr> <M-l>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<M-l>'"
    vim.cmd.imap "<expr> <M-h> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<M-h>'"
    vim.cmd.smap "<expr> <M-h> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<M-h>'"
end

return M
