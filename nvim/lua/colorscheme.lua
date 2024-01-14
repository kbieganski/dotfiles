-- Colorscheme
--------------
local M = {}

function M.setup()
    local colors = {
        inactive_bg = '#000000',
        active_bg = '#111111',
        cursorline = '#222222',
        lineno = '#444444',
        comment = '#777777',
        delimiter = '#888888',
        preproc = '#999999',
        operator = '#aaaaaa',
        constant = '#bbbbbb',
        type = '#cccccc',
        special = '#dddddd',
        identifier = '#eeeeee',
        normal = '#eeeeee',
        green = '#44ff88',
        red = '#ff4488',
        blue = '#2244ff',
        yellow = '#eeee22'
    }

    for hi, def in pairs(vim.api.nvim_get_hl(0, {})) do
        if hi ~= 'Normal' and not def.link then
            vim.api.nvim_set_hl(0, hi, { link = 'Normal' })
        end
    end

    vim.api.nvim_set_hl(0, 'Normal', { fg = colors.normal })
    vim.api.nvim_set_hl(0, 'NormalNC', {  })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = colors.cursorline })

    vim.api.nvim_set_hl(0, 'Visual', { bg = colors.blue })

    vim.api.nvim_set_hl(0, 'Keyword', { bold = true })
    vim.api.nvim_set_hl(0, 'Conditional', { link = 'Keyword' })
    vim.api.nvim_set_hl(0, 'Repeat', { link = 'Keyword' })

    vim.api.nvim_set_hl(0, 'Type', { fg = colors.type })
    vim.api.nvim_set_hl(0, 'Identifier', { fg = colors.identifier })
    vim.api.nvim_set_hl(0, 'Constant', { italic = true, fg = colors.constant })
    vim.api.nvim_set_hl(0, 'PreProc', { fg = colors.preproc })

    vim.api.nvim_set_hl(0, 'Comment', { fg = colors.comment })

    vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.lineno })

    vim.api.nvim_set_hl(0, 'Operator', { bold = true, fg = colors.operator })
    vim.api.nvim_set_hl(0, 'Delimiter', { fg = colors.delimiter })

    vim.api.nvim_set_hl(0, 'Special', { fg = colors.special })

    vim.api.nvim_set_hl(0, 'DiffAdd', { fg = colors.green })
    vim.api.nvim_set_hl(0, 'DiffDelete', { fg = colors.red })
    vim.api.nvim_set_hl(0, 'DiffChanged', { fg = colors.blue })

    vim.api.nvim_set_hl(0, 'Error', { fg = colors.red })
    vim.api.nvim_set_hl(0, 'DiagnosticError', { link = 'Error' })
    vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = colors.red })
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

    vim.api.nvim_set_hl(0, 'Search', { bg = colors.blue })
    vim.api.nvim_set_hl(0, 'IncSearch', { link = 'Search' })

    vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = '#333333' })
    vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = '#333333' })
    vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = '#333333' })

    vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true, sp = colors.red })

    vim.api.nvim_set_hl(0, 'Title', { bold = true, fg = '#bbbbbb' })

    vim.api.nvim_set_hl(0, 'markdownUrl', { underdashed = true })
    vim.api.nvim_set_hl(0, 'markdownUrlTitle', { underdotted = true })

    vim.api.nvim_set_hl(0, 'VertSplit', { fg = colors.active_bg, bg = colors.active_bg })
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { link = 'FloatBorder' })
    vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'FloatBorder' })
end

return M
