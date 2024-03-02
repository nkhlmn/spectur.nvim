local api = vim.api
local utils = require('spectur.utils')

local M = {
  opts = {
    notify = true,
    output = 'float',
  }
}

M.output_strategy = {
  ['tab'] = function(url)
    vim.cmd.tabnew()
    local parsed_url = utils.parse_url(url)
    local output_table = utils.split_str(parsed_url, '\n')
    local current_buffer = api.nvim_win_get_buf(0)
    api.nvim_buf_set_lines(current_buffer, 0, 0, false, { url })
    api.nvim_buf_set_lines(current_buffer, 2, #output_table + 5, false, output_table)
  end,

  ['float'] = function(url)
    local parsed_url = utils.parse_url(url)
    local output_table = utils.split_str(parsed_url, '\n')
    local opts = {
      pad_top = 1,
      border = 'single',
      title = 'Spectur:',
      title_pos = 'left',
    }
    vim.lsp.util.open_floating_preview(output_table, '', opts)
  end,

  ['notify'] = function(url)
    local parsed_url = utils.parse_url(url)
    vim.notify(url)
    vim.notify(parsed_url)
  end,

  ['cursor'] = function(url)
    vim.notify('TODO: ' .. url)
  end,
}

function M.run(url)
  local opts = M.opts

  M.output_strategy[M.opts.output](url)

  if opts.notify then
    vim.notify('URL parsed')
  end
end

return M
