local utils = require('spectur.utils')

---@alias UrlParams { [string]: string }

---@class (exact) UrlComponents table
---@field url string
---@field domain_path string|nil
---@field fragment string|nil
---@field port string|nil
---@field scheme string|nil
---@field params UrlParams|nil

---@class (exact) Url
---@field new fun(url: string): UrlComponents
local M = {}

---parse a string of query params into a table e.g. foo=bar&abc=123 -> { foo = "bar", abc = "123" }
---@param param_str string
---@return UrlParams
local function parse_params(param_str)
  local params = {}
  for k, v in param_str:gmatch('([^&=?]-)=([^&=?]+)') do
    params[k] = v
  end
  return params
end

---@param url string
---@return UrlComponents
function M.new(url)
  local components = {
    url = url
  }

  url = utils.decode(url)

  -- extract fragment
  for a, b in url:gmatch('(.+)#(.+)$') do
    url = a
    components.fragment = b
  end

  -- extract params
  for a, b in url:gmatch('(.+)%?(.+)$') do
    url = a
    components.params = parse_params(b)
  end

  -- extract scheme
  for a, b in url:gmatch('(.+)://(.+)$') do
    url = b
    components.scheme = a
    components.domain_path = b
  end

  -- extract port
  for a, b, c in url:gmatch('(.+):(%d+)/(.+)$') do
    components.port = b
    components.domain_path = a .. '/' .. c
  end

  return components
end

return M
