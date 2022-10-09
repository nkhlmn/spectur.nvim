local inspectur = require("inspectur")
local api = vim.api

local function handle_command(args)
	local arg = args.fargs[1]
	if arg ~= nil then
		inspectur.parse_url(args.fargs[1])
	else
    local input = vim.fn.input('URL: ')
		inspectur.parse_url(input)
	end
end

api.nvim_create_user_command("Spectur", handle_command, { nargs = "?" })
