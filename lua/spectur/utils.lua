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
function M.clean_url(url)
  url = string.gsub(url, '%%5[Bb]', '[')
  url = string.gsub(url, '%%5[Dd]', ']')
  url = string.gsub(url, '%%2[Ff]', '/')
  return url
end

return M
