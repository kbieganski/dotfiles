local M = {}

local function make_highlight_map(base_name)
  local result = {}
  for k in pairs(diagnostic_severities) do
    local name = M.severity[k]
    name = name:sub(1, 1) .. name:sub(2):lower()
    result[k] = 'Diagnostic' .. base_name .. name
  end

  return result
end

function f()
    g(a, b, c)
end


function M.make_diag_window()
    local focus_id = "diagnostic_lines"
    local current_winnr = vim.api.nvim_get_current_win()
    if vim.F.npcall(vim.api.nvim_win_get_var, current_winnr, focus_id) then
        return
    end
    local lines_above = vim.fn.winline() - 1
    local lines_below = vim.fn.winheight(0) - lines_above
    local row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
    local float_lines = {}
    local diags = vim.diagnostic.get(0)
    diags = vim.tbl_filter(function(diag) return diag.lnum + 1 == row end, diags)
    if #diags == 0 then
        return
    end
    if lines_above < lines_below then
        table.sort(diags, function(a, b) return a.col > b.col end)
    else
        table.sort(diags, function(a, b) return a.col < b.col end)
    end
    local prefix = '│'
    local last_col = diags[1].col
    diags[1].turn_sym = lines_above < lines_below and '└ ' or '┌ '
    local i = 2
    while i <= #diags do
        if diags[i].col == last_col then
            --table.remove(diags, i)
            --  │
            --  ├►
            --  ▼
            diags[i].turn_sym = '├ '
        else
            diags[i].turn_sym = lines_above < lines_below and '└ ' or '┌ '
            prefix = '│' .. string.rep(' ', math.abs(last_col - diags[i].col) - 1) .. prefix
            last_col = diags[i].col
        end
        i = i + 1
    end
    last_col = -1
    for _, diag in ipairs(diags) do
        local message = diag.message
        local idx = string.find(diag.message, "\n")
        if idx then
            message = string.sub(diag.message, 1, idx - 1)
        end
        prefix = vim.trim(prefix)
        local my_prefix = prefix:sub(1, #prefix - #('│'))
        if diag.col ~= last_col then
            prefix = my_prefix
        end
        message = my_prefix .. diag.turn_sym .. vim.diagnostic.severity[diag.severity] .. ' ' .. message
        idx = lines_above < lines_below and #float_lines + 1 or 1
        table.insert(float_lines, idx, message)
        last_col = diag.col
    end
    local first_col = lines_above < lines_below and diags[1].col or diags[#diags].col
    local bufnr, _ = vim.lsp.util.open_floating_preview(float_lines, 'markdown',
        { offset_x = first_col - cursor_col - 1, focus_id = focus_id, wrap = false })
    --vim.api.nvim_buf_add_highlight(bufnr, -1, 'DiagnosticError' 0, 0, -1)
end

function M.setup()
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = vim.api.nvim_create_augroup('auto_diag_window', { clear = true }),
        callback = M.make_diag_window,
    })
end

return M
