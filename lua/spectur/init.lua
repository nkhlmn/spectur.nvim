local api = vim.api
local utils = require('spectur.utils')
local Url  = require('spectur.url')

---@class (exact) Opts
---@field notify boolean
---@field output 'tab' | 'float' | 'notify' | 'cursor'
local default_opts = {
  notify = true,
  output = 'tab',
}

---@class (exact) Spectur
---@field opts Opts
---@field run fun(url: string, opts?: Opts)
local M = {
  opts = default_opts,
}

---@type table<string, fun(url: string)>
local output_strategy = {
  ['tab'] = function(url)
    vim.cmd.tabnew()
    local components = Url:new(url).components
    local components_str = vim.inspect(components)
    local lines = utils.split_str(components_str, '\n')
    local current_buffer = api.nvim_win_get_buf(0)
    api.nvim_buf_set_lines(current_buffer, 0, 0, false, lines)
  end,

  ['float'] = function(url)
    local components = Url:new(url).components
    local components_str = vim.inspect(components)
    local lines = utils.split_str(components_str, '\n')
    local opts = {
      pad_top = 1,
      border = 'single',
      title = 'Spectur:',
      title_pos = 'left',
      relative = 'editor'
    }
    vim.lsp.util.open_floating_preview(lines, '', opts)
  end,

  ['notify'] = function(url)
    local components = Url:new(url).components
    local components_str = vim.inspect(components)
    local lines = utils.split_str(components_str, '\n')
    vim.notify(lines)
  end,

  ['cursor'] = function(url)
    local components = Url:new(url).components
    local components_str = vim.inspect(components)
    local lines = utils.split_str(components_str, '\n')
    local opts = {
      pad_top = 1,
      border = 'single',
      title = 'Spectur:',
      title_pos = 'left',
    }
    vim.lsp.util.open_floating_preview(lines, '', opts)
  end,
}

---display the parsed url specified by the opts
---@param url string
---@param opts Opts|nil
function M.run(url, opts)
  if opts == nil then
    opts = M.opts
  end

  output_strategy[opts.output](url)

  if opts.notify then
    vim.notify('URL parsed')
  end
end

return M
