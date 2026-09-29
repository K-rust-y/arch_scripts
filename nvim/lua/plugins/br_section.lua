local M = {}
M.old_statusline = nil
M.enabled = false
M.cache = {}

function M.toggle()

  if M.enabled then
    -- disable plugin
    M.enabled = false
    if M.old_statusline then
      vim.opt.statusline = M.old_statusline
    end
    vim.notify("Section plugin disabled")

  else
    -- enable plugin
    M.enabled = true

    if not M.old_statusline then
      M.old_statusline = vim.opt.statusline:get()
    end

    vim.opt.statusline =
      M.old_statusline .. " %{v:lua.require'plugins.br_section'.statusline_section()}"

    vim.notify("Section plugin enabled")
  end
  vim.cmd("redrawstatus")
end

-- Parse sections in the buffer once and cache them
function M.build_cache(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local sections = {}
  for i, l in ipairs(lines) do
    -- local header = l:match("^%-%-%-%-%-%-%s*(.+)")
    -- local header = l:match("^DUMP OF SERVICE(.+)")
	local header = l:match("^DUMP OF SERVICE(.+):") or l:match("^------ (SYSTEM LOG.+)") or l:match("^---[-]*(.*LOG.*)") 
	--or l:match("(.*dumpsys.*)")
    if header then
      table.insert(sections, {line=i, name=header})
    end
  end
  M.cache[bufnr] = sections
end

-- Find the current section given cursor position
function M.current_section()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor[1]

  -- Build cache if not present
  if not M.cache[bufnr] then
    M.build_cache(bufnr)
  end

  local sections = M.cache[bufnr]
  local last_section = "No section"

  -- Binary search for efficiency on large files
  local left, right = 1, #sections
  while left <= right do
    local mid = math.floor((left + right) / 2)
    if sections[mid].line <= line_num then
      last_section = sections[mid].name
      left = mid + 1
    else
      right = mid - 1
    end
  end

  return last_section
end

-- Show section in status line
function M.statusline_section()
  return "Section: " .. M.current_section()
end

-- Setup function to configure autocommands
function M.setup(opts)
  if not M.enabled then
    return
  end
  vim.opt.statusline = vim.opt.statusline:get() .. " %{v:lua.require'plugins.br_section'.statusline_section()}"
  -- Invalidate cache on buffer reload
  vim.api.nvim_create_autocmd({"BufReadPost"}, {
    callback = function(args)
      M.cache[args.buf] = nil
    end
  })
end

return M
