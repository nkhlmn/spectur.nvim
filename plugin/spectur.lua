local spectur = require("spectur")
local api = vim.api

local function handle_command(args)
  local arg = args.fargs[1]
  if arg == nil then
    arg = vim.fn.input('URL: ')
  end
  spectur.run(arg)
end

api.nvim_create_user_command("Spectur", handle_command, { nargs = "?" })
