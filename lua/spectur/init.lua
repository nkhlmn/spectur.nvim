local api = vim.api

local M = {}

local function str_to_table(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

local function split_url_components(url)
  url = string.gsub(url, '%%5[Bb]', '[')
  url = string.gsub(url, '%%5[Dd]', ']')
  url = string.gsub(url, '%%2[Ff]', '/')
  url = string.gsub(url, '?', '\n\n?\n')
  url = string.gsub(url, '#', '\n\n#\n')
  url = string.gsub(url, '&', '\n\n&\n')
  return url
end

local function open_results(opts)
  local url = opts.url
  local output_table = opts.output_table
  local current_row = 0
  local insert_row_start = current_row + 3
  local insert_row_end = insert_row_start + #output_table + 2
  vim.cmd.tabnew()
  local current_buffer = api.nvim_win_get_buf(0)
  api.nvim_buf_set_lines(current_buffer, 0, 0, false, { url })
  api.nvim_buf_set_lines(current_buffer, 2, insert_row_end, false, output_table)
  vim.notify('URL parsed')
end

function M.parse_url(url)
  local formatted_line = split_url_components(url)
  local output_table = str_to_table(formatted_line, '\n')
  open_results({ url = url, output_table = output_table })
end

return M

