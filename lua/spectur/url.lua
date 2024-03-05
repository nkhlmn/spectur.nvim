local utils = require('spectur.utils')

---@alias UrlParams { [string]: string }

---@class UrlComponents table
---@field url string
---@field path string|nil
---@field fragment string|nil
---@field port string|nil
---@field scheme string|nil
---@field params UrlParams|nil

---@class (exact) Url
---@field components UrlComponents
---@field new fun(self, url: string): Url
local Url = {}

local function clean_url(url)
  url = string.gsub(url, '%%5[Bb]', '[')
  url = string.gsub(url, '%%5[Dd]', ']')
  url = string.gsub(url, '%%2[Ff]', '/')
  return url
end

---@param param_str string
---@return UrlParams
local function parse_params(param_str)
  local params = {}
  local param_pairs = utils.split_str(param_str, '&')
  for _, el in ipairs(param_pairs) do
    local k_v = utils.split_str(el, '=')
    local k = k_v[1]
    local v = k_v[2]
    params[k] = v
  end
  return params
end

---@param url string
---@return Url
function Url:new(url)
  url = clean_url(url)
  local components = {}
  components.url = url

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
    components.path = b
  end

  -- extract port
  for a, b, c in url:gmatch('(.+):(%d+)/(.+)$') do
    components.port = b
    components.path = a .. '/' .. c
  end

  self.components = components

  return self
end

return Url
