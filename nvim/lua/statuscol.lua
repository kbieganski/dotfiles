-- Status column
----------------
local M = {}

function M.get_signs()
  local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  return vim.tbl_map(function(sign)
    return vim.fn.sign_getdefined(sign.name)[1]
  end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
end

function M.make_column()
  local sign, git_sign
  for _, s in ipairs(M.get_signs()) do
    if s.name:find("GitSign") then
      git_sign = s
    else
      sign = s
    end
  end
  local components = {
    sign and ("%#" .. sign.texthl .. "#" .. sign.text .. "%*") or " ",
    [[%=]],
    [[%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''} ]],
    git_sign and ("%#" .. git_sign.texthl .. "#" .. git_sign.text .. "%*") or "  ",
  }
  return table.concat(components, "")
end

_G.status_column = M.make_column

function M.setup()
    vim.o.statuscolumn = [[%!v:lua.status_column()]]
end

return M
