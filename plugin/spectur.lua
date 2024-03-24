local spectur = require('spectur')

local function handle_command(args)
	local arg = args.fargs[1]
	if arg == nil then
		arg = vim.fn.input('URL: ')
	end
	spectur.display(arg)
end

local function handle_cursor_command()
  local cword = vim.fn.expand('<cWORD>')
  if cword ~= nil and cword ~= '' then
    spectur.display(cword, { output = 'cursor' })
  end
end

vim.api.nvim_create_user_command('Spectur', handle_command, { nargs = '?' })
vim.api.nvim_create_user_command('SpecturCursor', handle_cursor_command, { nargs = 0 })
