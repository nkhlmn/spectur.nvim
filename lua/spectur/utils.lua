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

---replace escaped characters
---@param url string
---@return string
function M.decode(url)
  local hex_to_char = function(h)
    return string.char(tonumber(h, 16))
  end
  url = url:gsub('+', ' ')
  url = url:gsub('%%(%x%x)', hex_to_char)
  return url
end

return M
