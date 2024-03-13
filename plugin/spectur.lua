local spectur = require('spectur')

local function handle_command(args)
	local arg = args.fargs[1]
	if arg == nil then
		arg = vim.fn.input('URL: ')
	end
	spectur.display(arg)
end

vim.api.nvim_create_user_command('Spectur', handle_command, { nargs = '?' })
