local utils = require('spectur.utils')
local Url = require('spectur.url')

local M = {}

---@param url string
---@return string[]
function M.get_view_contents(url)
  local components = Url:new(url).components
  local components_str = vim.inspect(components)
  local lines = utils.split_str(components_str, '\n')
  return lines
end

---@type table<string, fun(url: string)>
M.handlers = {
  ['tab'] = function(url)
    vim.cmd.tabnew()
    local lines = M.get_view_contents(url)
    local buf = vim.api.nvim_win_get_buf(0)
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
    vim.api.nvim_buf_set_option(buf, "filetype", "json")
    vim.api.nvim_buf_set_option(buf, "syntax", "on")
  end,

  ['float'] = function(url)
    local lines = M.get_view_contents(url)
    local buf = vim.api.nvim_create_buf(false, true)
    local ui = vim.api.nvim_list_uis()[1]
    local content_width = 1
    for _, l in ipairs(lines) do
      if #l > content_width then
        content_width = #l
      end
    end
    vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = content_width + 1,
      height = #lines + 1,
      row = (ui.height / 2) - (#lines / 2),
      col = (ui.width / 2) - (content_width / 2),
      style = 'minimal',
      border = 'single',
      title = 'Spectur:',
      title_pos = 'left',
      noautocmd = true,
    })
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
    vim.api.nvim_buf_set_option(buf, "filetype", "json")
    vim.api.nvim_buf_set_option(buf, "syntax", "on")

    local keymap_opts = { silent = true, buffer = true }
    vim.keymap.set("n", "q", function() vim.api.nvim_win_close(0, true) end, keymap_opts)
    vim.keymap.set("n", "<ESC>", function() vim.api.nvim_win_close(0, true) end, keymap_opts)
  end,

  ['cursor'] = function(url)
    local lines = M.get_view_contents(url)
    local opts = {
      pad_top = 1,
      border = 'single',
      title = 'Spectur:',
      title_pos = 'left',
    }
    vim.lsp.util.open_floating_preview(lines, 'json', opts)
  end,

  ['notify'] = function(url)
    local lines = M.get_view_contents(url)
    vim.notify(lines)
  end,
}

return M
