local M = {}

M._entries = setmetatable({}, {
  __index = function(tbl, key)
    local entry = rawget(tbl, key)

    if not entry then
      entry = {
        src_to_asm = {},
        asm_lines = {},
        labels = {},
        used_labels = {},
        files = {},
      }
      rawset(tbl, key, entry)
    end

    return entry
  end,
})

M.config = {
  highlight = 'CompilerExplorer',
  strip_comments = true,
  strip_directives = true,
  strip_unused_labels = true, -- FIXME: directives before code get stripped
  x86_syntax = 'intel',
  keys = {
    close = 'q',
  },
}

local comp_explr_ns = vim.api.nvim_create_namespace 'compiler-explorer'

local augroup = vim.api.nvim_create_augroup('compiler-explorer.nvim', {})

local function close_buf_windows(buf)
  if not vim.api.nvim_buf_is_loaded(buf) then
    return
  end
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_close(win, true)
  end
end

local function close_buf(buf)
  close_buf_windows(buf)
  if vim.api.nvim_buf_is_loaded(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

local function clear_entry(buf)
  local entry = M._entries[buf]
  if entry.asm_buf then
    close_buf(entry.asm_buf)
  end
  M._entries[buf] = nil
end

local function is_buf_visible(buf)
  local windows = vim.fn.win_findbuf(buf)

  return #windows > 0
end

local function asm_ln_to_src_loc(src_buf, asm_ln)
  local entry = M._entries[src_buf]
  if entry.asm_lines[asm_ln] then
    local line = entry.asm_lines[asm_ln]
    return line.loc, line.end_loc
  end
  return nil, nil
end

local function highlight_src(src_buf, src_loc, end_loc)
  vim.api.nvim_buf_clear_namespace(src_buf, comp_explr_ns, 0, -1)
  local _, lnum, col = unpack(src_loc)
  local end_col = end_loc and end_loc[3] or -1
  vim.api.nvim_buf_add_highlight(src_buf, comp_explr_ns, M.config.highlight, lnum - 1, col - 1, end_col - 1)
end

local function goto_src(src_buf, src_loc)
  local _, lnum, col = unpack(src_loc)
  for _, src_win in ipairs(vim.fn.win_findbuf(src_buf)) do
    vim.api.nvim_win_set_cursor(src_win, { lnum, col - 1 })
  end
end

local function src_ln_to_asm_range(src_buf, src_ln)
  local entry = M._entries[src_buf]
  if entry.src_to_asm[src_ln] then
    return entry.src_to_asm[src_ln]
  end
  return nil
end

local function highlight_asm(asm_buf, asm_range)
  vim.api.nvim_buf_clear_namespace(asm_buf, comp_explr_ns, 0, -1)
  local first_ln, last_ln = unpack(asm_range)
  for ln = first_ln, last_ln do
    vim.api.nvim_buf_add_highlight(asm_buf, comp_explr_ns, M.config.highlight, ln - 1, 0, -1)
  end
end

local function goto_asm(asm_buf, asm_range)
  local first_ln, last_ln = unpack(asm_range)
  for _, asm_win in ipairs(vim.fn.win_findbuf(asm_buf)) do
    local lnum, col = unpack(vim.api.nvim_win_get_cursor(asm_win))
    if lnum < first_ln or lnum > last_ln then
      vim.api.nvim_win_set_cursor(asm_win, { first_ln, col })
    end
  end
end

local function setup_buf(src_buf)
  if M._entries[src_buf].asm_buf then
    return M._entries[src_buf].asm_buf
  end

  local asm_buf = vim.api.nvim_create_buf(false, false)

  vim.api.nvim_buf_set_name(asm_buf, 'compiler-explorer.nvim')
  vim.api.nvim_buf_set_option(asm_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(asm_buf, 'swapfile', false)
  vim.api.nvim_buf_set_option(asm_buf, 'buflisted', false)
  vim.api.nvim_buf_set_option(asm_buf, 'filetype', 'compiler-explorer')
  vim.api.nvim_buf_set_option(asm_buf, 'syntax', 'asm')
  if M.config.keys.close then
    vim.keymap.set('n', M.config.keys.close, function() close_buf_windows(asm_buf) end,
      { buffer = asm_buf, silent = true })
  end

  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufWrite', 'FileChangedShell' }, {
    group = augroup,
    buffer = asm_buf,
    callback = function()
      M.update(src_buf)
    end,
    desc = 'compiler-explorer.nvim: update assembly',
  })
  vim.api.nvim_create_autocmd('CursorMoved', {
    group = augroup,
    buffer = asm_buf,
    callback = function()
      vim.api.nvim_buf_clear_namespace(asm_buf, comp_explr_ns, 0, -1)
      local asm_lnum, _ = unpack(vim.api.nvim_win_get_cursor(0))
      local src_loc, end_loc = asm_ln_to_src_loc(src_buf, asm_lnum)
      if src_loc then
        highlight_src(src_buf, src_loc, end_loc)
        goto_src(src_buf, src_loc)
        local _, src_ln, _ = unpack(src_loc)
        local asm_range = src_ln_to_asm_range(src_buf, src_ln)
        highlight_asm(asm_buf, asm_range)
      end
    end,
    desc = 'compiler-explorer.nvim: highlight source',
  })
  vim.api.nvim_create_autocmd('CursorMoved', {
    group = augroup,
    buffer = src_buf,
    callback = function()
      local src_ln, _ = unpack(vim.api.nvim_win_get_cursor(0))
      local asm_range = src_ln_to_asm_range(src_buf, src_ln)
      if asm_range then
        highlight_asm(asm_buf, asm_range)
        goto_asm(asm_buf, asm_range)
      end
    end,
    desc = 'compiler-explorer.nvim: highlight assembly',
  })
  vim.api.nvim_create_autocmd('BufLeave', {
    group = augroup,
    buffer = asm_buf,
    callback = function()
      vim.api.nvim_buf_clear_namespace(src_buf, comp_explr_ns, 0, -1)
      vim.api.nvim_buf_clear_namespace(asm_buf, comp_explr_ns, 0, -1)
    end,
    desc = 'compiler-explorer.nvim: clear highlights',
  })
  vim.api.nvim_create_autocmd('BufLeave', {
    group = augroup,
    buffer = src_buf,
    callback = function()
      vim.api.nvim_buf_clear_namespace(asm_buf, comp_explr_ns, 0, -1)
    end,
    desc = 'compiler-explorer.nvim: clear source highlight',
  })

  return asm_buf
end



local function parse_comment(line)
  local idx = line:find('#')
  if idx then
    return line:sub(1, idx - 1), line:sub(idx)
  end
  return line, ''
end

local function render_line(line)
  return line.code .. line.comment
end

local function parse_directive(line)
  local directive, args = nil, nil
  if line:sub(1, 1) == '.' then
    line = vim.split(line, '%s+')
    if line[1]:sub(#line[1]) ~= ':' then
      directive, args = line[1]:sub(2), vim.list_slice(line, 2)
    end
  end
  return directive, args
end

local function parse_label(line)
  if line:sub(1, 1) == '.' then
    line = vim.split(line, '%s+')
    if line[1]:sub(#line[1]) == ':' then
      return line[1]:sub(2, #line[1] - 1)
    end
  end
  return nil
end

local function parse_line(line)
  local code, comment = parse_comment(line)
  local res = { code = code, comment = comment }
  local trimmed = vim.trim(code)
  local directive, args = parse_directive(trimmed)
  if directive then
    res.directive = directive
    res.args = args
  else
    res.label = parse_label(trimmed)
  end
  return res
end

local function fill_previous_end_loc(lines, i, loc)
  local file, lnum, col = unpack(loc)
  for j = i - 1, 1, -1 do
    local prev_loc = lines[j].loc
    if not prev_loc then
      break
    else
      local prev_file, prev_lnum, _ = unpack(prev_loc)
      if file ~= prev_file or lnum > prev_lnum then
        break
      elseif col > prev_loc[3] then
        local prev_end_loc = lines[j].end_loc
        if not prev_end_loc or prev_end_loc[3] > col then
          lines[j].end_loc = loc
        end
      end
    end
  end
end

local function post_process(entry, lines)
  local loc = nil
  for i, line in ipairs(lines) do
    if line.label then
      entry.labels[line.label] = i
    elseif line.directive then
      if line.directive == 'file' then
        local file_id = tonumber(line.args[1])
        local file = line.args[2]
        if line.args[3] then
          file = file .. '/' .. line.args[3]
        end
        if file_id then
          entry.files[file_id] = file
        end
      elseif line.directive == 'loc' then
        local file_id = tonumber(line.args[1])
        loc = { entry.files[file_id], tonumber(line.args[2]), tonumber(line.args[3]) }
        fill_previous_end_loc(lines, i, loc)
      end
    elseif M.config.strip_unused_labels then
      local first, last = line.code:find('%.[%w%d]+')
      if first and last then
        entry.used_labels[line.code:sub(first + 1, last)] = true
      end
    end
    line.loc = loc
    if vim.trim(line.code) == 'ret' then
      loc = nil
    end
  end
end

local function filter_lines(entry, lines)
  local new_lines = {}
  local skip = false
  for _, line in ipairs(lines) do
    if M.config.strip_comments then
      if line.code == '' then
        line = nil
      else
        line.comment = ''
      end
    end

    if line then
      if line.directive then
        if M.config.strip_directives and line.directive ~= 'string' then
          line = nil
        end
      else
        skip = M.config.strip_unused_labels and line.label and not entry.used_labels[line.label]
      end
      if skip then
        line = nil
      end
    end

    if line then
      new_lines[#new_lines + 1] = line
      if line.label then
        entry.labels[line.label] = #new_lines
      end
    end
  end
  return new_lines
end

local function map_src_to_asm(lines)
  -- TODO: more granular mapping
  local asm_ranges = {}
  local loc = nil
  for i, line in ipairs(lines) do
    loc = line.loc
    if loc then
      local src_ln = loc[2]
      local asm_range = asm_ranges[src_ln]
      if asm_range then
        asm_range[2] = i
      else
        asm_ranges[src_ln] = { i, i }
      end
    end
  end
  return asm_ranges
end

local compilers = {
  gcc = {
    command = function(file)
      return 'gcc -g -S -masm=' .. M.config.x86_syntax .. ' -o - ' .. file .. ' 2>/dev/null'
    end,
  },
  clang = {
    command = function(file)
      return 'clang -g -S -mllvm --x86-asm-syntax=' .. M.config.x86_syntax .. ' -o - ' .. file .. ' 2>/dev/null'
    end,
  },
}

function M.open(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local asm_buf = setup_buf(buf)
  local current_window = vim.api.nvim_get_current_win()

  M._entries[buf].asm_buf = asm_buf
  vim.cmd 'vsplit'
  vim.cmd(string.format('buffer %d', asm_buf))

  vim.api.nvim_win_set_option(0, 'spell', false)
  vim.api.nvim_win_set_option(0, 'number', false)
  vim.api.nvim_win_set_option(0, 'relativenumber', false)
  vim.api.nvim_win_set_option(0, 'cursorline', false)

  vim.api.nvim_set_current_win(current_window)


  return asm_buf
end

function M.toggle(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local asm_buf = nil
  if vim.api.nvim_buf_get_option(buf, 'filetype') == 'compiler-explorer' then
    asm_buf = buf
  else
    asm_buf = M._entries[buf].asm_buf
  end
  if asm_buf and is_buf_visible(asm_buf) then
    close_buf_windows(asm_buf)
  else
    M.open(buf)
  end
end

function M.update(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local entry = M._entries[buf]
  local asm_buf = entry.asm_buf

  if not asm_buf or not is_buf_visible(asm_buf) then
    return
  end

  local compiler = compilers.gcc
  local compiler_output = vim.fn.system(compiler.command(vim.api.nvim_buf_get_name(buf)))
  local asm_lines = vim.tbl_map(parse_line, vim.split(compiler_output, '\n'))
  post_process(entry, asm_lines)
  asm_lines = filter_lines(entry, asm_lines)

  entry.asm_lines = asm_lines
  entry.src_to_asm = map_src_to_asm(asm_lines)

  local asm_buf_lines = vim.tbl_map(render_line, entry.asm_lines)

  vim.api.nvim_buf_set_option(asm_buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(asm_buf, 0, -1, false, asm_buf_lines)
  vim.api.nvim_buf_set_option(asm_buf, 'modifiable', false)
end

return M
