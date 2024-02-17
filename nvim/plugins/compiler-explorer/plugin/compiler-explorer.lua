vim.api.nvim_set_hl(0, 'CompilerExplorer', { link = 'Visual', default = true })

vim.api.nvim_create_user_command('CompilerExplorer', function()
  require 'compiler-explorer'.toggle()
end, {})
