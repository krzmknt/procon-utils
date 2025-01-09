local M = {}


local function number_to_letter(num)
  local result = ""
  num = tonumber(num)
  while num > 0 do
    num = num - 1
    result = string.char((num % 26) + 97) .. result
    num = math.floor(num / 26)
  end
  return result
end

local function open_url_in_browser(url)
  local open_command = "xdg-open"
  if vim.loop.os_uname().sysname == "Darwin" then
    open_command = "open"
  elseif vim.loop.os_uname().sysname:match("Windows") then
    open_command = "start"
  end
  os.execute(open_command .. " " .. url)
end

local function get_url_atcoder(problem_set, problem_id)
  local problem_letter = problem_id
  if problem_set == "typical90" then
    problem_letter = number_to_letter(problem_id)
  end

  return string.format("https://atcoder.jp/contests/%s/tasks/%s_%s", problem_set, problem_set, problem_letter)
end

function M.open_url()
  local file_path = vim.api.nvim_buf_get_name(0)
  local contest_name, problem_set, problem_id = file_path:match("([^/]+)/([^/]+)/([^/]+)/[^/]+$")
  print(file_path, contest_name, problem_set, problem_id)

  if not contest_name or not problem_set or not problem_id then
    print("Unable to parse contest information.")
    return
  end

  local url = ""
  if contest_name == "atcoder" then
    url = get_url_atcoder(problem_set, problem_id)
  else
    print("Unsupported contest: " .. contest_name)
    return
  end

  open_url_in_browser(url)
end

vim.api.nvim_create_user_command("ProconOpenUrl", function()
  M.open_url()
end, {})

return M
