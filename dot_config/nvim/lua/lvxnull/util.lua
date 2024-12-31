local M = {}

---Copy all entries from source to dest and return dest
---@param dest table
---@param source table
---@return table dest
function M.merge(dest, source)
  for k, v in pairs(source) do
    dest[k] = v
  end
  return dest
end

---A wrapper around `vim.keymap.set`. Silent by default. If `desc` is a table
---and `opts` is nil, options are read from `desc` instead.
---@param mode string|string[]
---@param lhs string
---@param rhs string|fun(): string?
---@param desc string|table? Keybind description
---@param opts table? Keybind options
function M.map(mode, lhs, rhs, desc, opts)
  if type(desc) == 'table' and not opts then
    opts = desc
    desc = nil
  end
  local o = M.merge({silent = true, desc = desc}, opts or {})
  vim.keymap.set(mode, lhs, rhs, o)
end

---Creates a lazy.nvim compatible plugin list from mixed table of plugin defs
---Useful for defining plugin configs outside the table
---@param t table
---@return table
function M.flatten_plugins(t)
  local ret = {}

  local i = #t + 1
  for k, v in pairs(t) do
    if type(k) == 'string' then
      if v.name ~= false then
        v.name = v.name or k
      else
        v.name = nil
      end

      ret[i] = v
      i = i + 1
    elseif type(k) == 'number' then
      ret[k] = v
    end
  end

  return ret
end

--- Is the buffer huge(either in lines or size on disk)
function M.is_huge(bufnr)
  local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
  local lines = vim.api.nvim_buf_line_count(bufnr)
  -- 2097152 = 2MiB
  -- -2 = too big to fit in a number

  return size == -2 or size >= 2097152 or lines >= 10000 or (size / lines) >= 400
end

function M.visual_selection()
  local lines = {}
  ---- not required since v0.10
  -- local lstart, cstart = unpack(vim.fn.getpos("'<"), 2, 3)
  -- local lend, cend = unpack(vim.fn.getpos("'>"), 2, 3)
  ----
  local inclusive = vim.o.selection ~= 'exclusive'
  local region = vim.region(0, "'<", "'>", vim.fn.visualmode(), inclusive)
  for line, cols in vim.spairs(region) do
    if cols[2] == vim.v.maxcol then
      cols[2] = -1
    end

    table.insert(lines, vim.api.nvim_buf_get_text(0, line, cols[1], line, cols[2], {})[1])
  end

  return table.concat(lines, '\n')
end

--- Linux make on *BSD is called gmake
if vim.fn.has('bsd') then
  M.make = 'gmake'
else
  M.make = 'make'
end

return M
