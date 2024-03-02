local M = {}

function M.split_str(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

function M.parse_url(url)
  url = string.gsub(url, '%%5[Bb]', '[')
  url = string.gsub(url, '%%5[Dd]', ']')
  url = string.gsub(url, '%%2[Ff]', '/')
  url = string.gsub(url, '?', '\n?\n')
  url = string.gsub(url, '#', '\n#\n')
  url = string.gsub(url, '&', '\n&\n')
  url = string.gsub(url, '=', ' = ')
  return url
end

return M
