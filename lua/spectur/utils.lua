local M = {}

---@param str string
---@param sep string
---@return string[]
function M.split_str(str, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for s in string.gmatch(str, '([^' .. sep .. ']+)') do
    table.insert(t, s)
  end
  return t
end

return M
