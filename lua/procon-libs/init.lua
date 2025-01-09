local M = {}

function M.hello_world()
  print("Hello, World!")
end

vim.api.nvim_create_user_command('HelloWorld', function()
  M.hello_world()
end, {})

return M
