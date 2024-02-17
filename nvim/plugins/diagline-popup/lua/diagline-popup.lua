local M = {}

---@private
--- Get data/functions that depend on the position of the floating window
---@return [function, function, string]
local function float_pos_dependent()
    local lines_above = vim.fn.winline() - 1
    local lines_below = vim.fn.winheight(0) - lines_above
    if lines_above < lines_below then
        return {
            function(a, b) return a.severity < b.severity end,
            function(_, i) return i - 1 end,
            '└─── ',
        }
    else
        return {
            function(a, b) return a.severity > b.severity end,
            function(diags, i) return #diags - i end,
            '┌─── ',
        }
    end
end

--- Make a floating window with the diagnostics of the current line
---@param opts (table, optional) Options
---        - focus (boolean) If true, an existing floating window will be focused
function M.show(opts)
    opts = opts or {}
    opts.focusable = opts.focusable == nil and true or opts.focusable
    local focus_id = "diagline-popup"

    local _, lnum, cur_col, cur_off = unpack(vim.fn.getpos [[.]])
    local diags = vim.diagnostic.get(0, { lnum = lnum - 1 })
    if #diags == 0 then return end

    local severity_less, float_line, connector_end = unpack(float_pos_dependent())

    table.sort(diags,
        function(a, b)
            if a.col == b.col then return severity_less(a, b) end
            return a.col > b.col
        end)

    local float_diags = {}
    for i, diag in ipairs(diags) do
        local message = diag.message
        local idx = message:find("\n")
        if idx then
            message = message:sub(1, idx - 1)
        end
        local severity = vim.diagnostic.severity[diag.severity]
        severity = severity:sub(1, 1):upper() .. severity:sub(2):lower()
        float_diags[i] = {
            float_line = float_line(diags, i),
            hi_group = 'Diagnostic' .. severity,
            other_connectors = '',
            connector_end = connector_end,
            message = message,
        }
        if i > 1 then
            local j = i - 1
            local prev_diag = diags[j]
            if diag.col == prev_diag.col then
                float_diags[j].connector_end = '├─── '
            else
                local new_connector = '│' .. (' '):rep(prev_diag.col - diag.col - 1)
                while j > 0 do
                    if diags[j].col ~= diag.col then
                        float_diags[j].other_connectors = new_connector .. float_diags[j].other_connectors
                    end
                    j = j - 1
                end
            end
        end
    end

    local float_contents = {}
    for _, diag in ipairs(float_diags) do
        local connectors = diag.other_connectors .. diag.connector_end
        diag.hi_col = #connectors
        float_contents[diag.float_line + 1] = connectors .. diag.message
    end

    local bufnr, _ = vim.lsp.util.open_floating_preview(float_contents, nil,
        {
            offset_x = diags[#diags].col - (cur_col + cur_off),
            focusable = opts.focusable,
            focus_id = focus_id,
            wrap = false
        })

    for _, diag in ipairs(float_diags) do
        vim.api.nvim_buf_add_highlight(bufnr, -1, 'FloatBorder', diag.float_line, 0, diag.hi_col)
        vim.api.nvim_buf_add_highlight(bufnr, -1, diag.hi_group, diag.float_line, diag.hi_col, -1)
    end
end

--- Setup the diagline-popup module
---@param opts (table?) Options
---        - events (table?) The events that trigger the floating window
function M.setup(opts)
    opts = opts or {}
    opts.events = opts.events == nil and { 'CursorHold', 'CursorHoldI' } or opts.events
    if #opts.events > 0 then
        vim.api.nvim_create_autocmd(opts.events, {
            group = vim.api.nvim_create_augroup('diagline-popup', { clear = true }),
            callback = function()
                for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                    if vim.api.nvim_win_get_config(win).zindex then
                        return
                    end
                end
                M.show { focusable = false }
            end,
        })
    end
end

return M
