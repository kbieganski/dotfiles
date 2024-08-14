local colors = {
    inactive_bg = '#000000',
    active_bg = '#111111',
    cursorline = '#222222',
    reference = '#333333',
    visual = '#444444',
    border = '#555555',
    lineno = '#666666',
    comment = '#777777',
    delimiter = '#888888',
    preproc = '#999999',
    operator = '#aaaaaa',
    constant = '#bbbbbb',
    type = '#cccccc',
    normal = '#dddddd',
    identifier = '#eeeeee',
    special = '#ffffff',
    green = '#44ff88',
    red = '#ff5577',
    blue = '#00aaff',
    yellow = '#ffcc00'
}

for hi, def in pairs(vim.api.nvim_get_hl(0, {})) do
    if hi ~= 'Normal' and not def.link then
        vim.api.nvim_set_hl(0, hi, { link = 'Normal' })
    end
end

vim.api.nvim_set_hl(0, 'Normal', { fg = colors.normal })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = colors.inactive_bg })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = colors.cursorline })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = colors.inactive_bg })
vim.api.nvim_set_hl(0, 'Visual', { bg = colors.visual })

vim.api.nvim_set_hl(0, 'MatchParen', { bold = true })

vim.api.nvim_set_hl(0, 'Keyword', { bold = true })
vim.api.nvim_set_hl(0, 'Conditional', { link = 'Keyword' })
vim.api.nvim_set_hl(0, 'Repeat', { link = 'Keyword' })

vim.api.nvim_set_hl(0, 'Type', { fg = colors.type })
vim.api.nvim_set_hl(0, 'Identifier', { fg = colors.identifier })
vim.api.nvim_set_hl(0, 'Constant', { italic = true, fg = colors.constant })
vim.api.nvim_set_hl(0, 'String', { link = 'Constant' })
vim.api.nvim_set_hl(0, 'Tag', { link = 'Constant' })
vim.api.nvim_set_hl(0, 'Label', { link = 'Constant' })
vim.api.nvim_set_hl(0, 'PreProc', { fg = colors.preproc })

vim.api.nvim_set_hl(0, 'Comment', { fg = colors.comment })

vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.lineno })

vim.api.nvim_set_hl(0, 'Operator', { bold = true, fg = colors.operator })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = colors.delimiter })

vim.api.nvim_set_hl(0, 'Special', { fg = colors.special })

vim.api.nvim_set_hl(0, 'Added', { fg = colors.green })
vim.api.nvim_set_hl(0, 'Removed', { fg = colors.red })
vim.api.nvim_set_hl(0, 'Changed', { fg = colors.blue })
vim.api.nvim_set_hl(0, 'DiffAdd', { link = 'Added' })
vim.api.nvim_set_hl(0, 'DiffDelete', { link = 'Removed' })
vim.api.nvim_set_hl(0, 'DiffChange', { link = 'Changed' })

vim.api.nvim_set_hl(0, 'Error', { fg = colors.red })
vim.api.nvim_set_hl(0, 'DiagnosticError', { link = 'Error' })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = colors.red })
vim.api.nvim_set_hl(0, 'NvimInvalid', { undercurl = true, sp = colors.red })
vim.api.nvim_set_hl(0, 'ErrorMsg', { link = 'Error' })

vim.api.nvim_set_hl(0, 'Warn', { fg = colors.yellow })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { link = 'Warn' })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = colors.yellow })
vim.api.nvim_set_hl(0, 'WarningMsg', { link = 'Warn' })

vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = colors.blue })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = colors.blue })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = colors.blue })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = colors.blue })

vim.api.nvim_set_hl(0, 'DiagnosticOk', { fg = colors.green })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineOk', { undercurl = true, sp = colors.green })

vim.api.nvim_set_hl(0, 'Search', { fg = colors.special, bg = colors.blue })
vim.api.nvim_set_hl(0, 'IncSearch', { link = 'Search' })

vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = colors.reference })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { link = 'LspReferenceText' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#442222' })

vim.api.nvim_set_hl(0, 'SpellBad', { link = 'DiagnosticUnderlineError' })
vim.api.nvim_set_hl(0, 'SpellCap', { link = 'DiagnosticUnderlineWarn' })
vim.api.nvim_set_hl(0, 'SpellRare', { link = 'DiagnosticUnderlineInfo' })
vim.api.nvim_set_hl(0, 'SpellLocal', { link = 'DiagnosticUnderlineWarn' })

vim.api.nvim_set_hl(0, 'Directory', { bold = true })

vim.api.nvim_set_hl(0, 'Title', { underline = true, bold = true, fg = colors.special })

vim.api.nvim_set_hl(0, 'markdownUrl', { underdashed = true })
vim.api.nvim_set_hl(0, 'markdownUrlTitle', { underdotted = true })

vim.api.nvim_set_hl(0, 'VertSplit', { fg = colors.border, bg = colors.active_bg })
vim.api.nvim_set_hl(0, 'FloatTitle', { link = 'FloatBorder' })
vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'FloatBorder' })
vim.api.nvim_set_hl(0, 'PmenuSel', { link = 'CursorLine' })

vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = colors.cursorline })
vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = colors.lineno, bg = colors.cursorline })

vim.api.nvim_set_hl(0, 'TelescopeBorder', { link = 'FloatBorder' })
vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = colors.active_bg })
vim.api.nvim_set_hl(0, 'TelescopeSelection', { link = 'CursorLine' })
vim.api.nvim_set_hl(0, 'TelescopeMatching', { link = 'Search' })
