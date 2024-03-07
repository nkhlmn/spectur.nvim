local view = require('spectur.view')

---@class (exact) Opts
---@field notify boolean
---@field output 'tab' | 'float' | 'notify' | 'cursor'
local default_opts = {
  notify = true,
  output = 'float',
}

---@class (exact) Spectur
---@field opts Opts
---@field run fun(url: string, opts?: Opts)
local M = {
  opts = default_opts,
}

---display the parsed url specified by the opts
---@param url string
---@param opts Opts|nil
function M.run(url, opts)
  if opts == nil then
    opts = M.opts
  end

  view.handlers[opts.output](url)

  if opts.notify then
    vim.notify('URL parsed')
  end
end

return M
