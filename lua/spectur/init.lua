local view = require('spectur.view')

---@class Opts
---@field notify boolean
---@field output 'tab' | 'float' | 'notify' | 'cursor'
---@field view_format 'toml' | 'json

local default_opts = {
  notify = true,
  output = 'float',
  view_format = 'toml',
}

---@class (exact) Spectur
---@field opts Opts
---@field display function
---@field setup function
local M = {
  opts = default_opts,
}

---display the parsed url specified by the opts
---@param url string
---@param opts? Opts
function M.display(url, opts)
  if opts == nil then
    opts = M.opts
  else
    opts = vim.tbl_deep_extend('force', M.opts, opts)
  end

  view.handlers[opts.output](url, opts)

  if opts.notify then
    vim.notify('URL parsed')
  end
end

---@param opts Opts
function M.setup(opts)
  M.opts = vim.tbl_deep_extend('force', M.opts, opts or {})
end

return M
