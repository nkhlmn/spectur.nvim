local utils = require('spectur.utils')
local Url = require('spectur.url')

local M = {}

---@param url UrlComponents
---@return string[]
function M.to_toml(url)
	local lines = {}

	local components_to_add = {
		'url',
		'scheme',
		'port',
		'domain_path',
		'fragment',
		'params',
	}

	for _, c in ipairs(components_to_add) do
		if url[c] == nil then
		-- do nothing
		elseif c ~= 'params' then
			table.insert(lines, c .. " = '" .. url[c] .. "'")
		else
			table.insert(lines, '')
			table.insert(lines, '[params]')
			for k, v in pairs(url.params) do
				table.insert(lines, k .. " = '" .. v .. "'")
			end
		end
	end

	return lines
end

---@param url string
---@return string[]
function M.get_view_contents(url, opts)
	if opts == nil then
		opts = { view_format = 'toml' }
	end
	local components = Url.new(url)
	local lines = {}

	if opts.view_format == 'toml' then
		lines = M.to_toml(components)
	elseif opts.view_format == 'json' then
		lines = utils.split_str(vim.inspect(components), '\n')
	end

	return lines
end

---@type table<string, fun(url: string, opts: Opts)>
M.handlers = {
	['tab'] = function(url, opts)
		vim.cmd.tabnew()
		local lines = M.get_view_contents(url, opts)
		local buf = vim.api.nvim_win_get_buf(0)
		vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
		vim.api.nvim_buf_set_option(buf, 'filetype', opts.view_format)
		vim.api.nvim_buf_set_option(buf, 'syntax', 'on')
	end,

	['float'] = function(url, opts)
		local lines = M.get_view_contents(url, opts)
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
		vim.api.nvim_buf_set_option(buf, 'filetype', opts.view_format)
		vim.api.nvim_buf_set_option(buf, 'syntax', 'on')
		vim.api.nvim_buf_set_option(buf, 'modifiable', false)

		local keymap_opts = { silent = true, buffer = true }
		vim.keymap.set('n', 'q', function()
			vim.api.nvim_win_close(0, true)
		end, keymap_opts)
		vim.keymap.set('n', '<ESC>', function()
			vim.api.nvim_win_close(0, true)
		end, keymap_opts)
	end,

	['cursor'] = function(url, opts)
		local lines = M.get_view_contents(url, opts)
		local float_opts = {
			pad_top = 1,
			border = 'single',
			title = 'Spectur:',
			title_pos = 'left',
		}
		vim.lsp.util.open_floating_preview(lines, opts.view_format, float_opts)
	end,

	['notify'] = function(url, opts)
		local lines = M.get_view_contents(url, opts)
		vim.notify(lines)
	end,
}

return M
