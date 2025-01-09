local M = {}


-- AtCoder URLを生成してブラウザで開く関数
function M.open_url()
  -- 現在開いているファイルのパスを取得
  local file_path = vim.api.nvim_buf_get_name(0)

  -- パスから `atcoder`, `contest_name`, `problem_set` を抽出
  local contest_path = file_path:match("atcoder/([^/]+)/([^/]+)/([^/]+)/")
  if not contest_path then
    print("AtCoder contest path not found in the file path.")
    return
  end

  local contest_name, problem_set, problem_id = contest_path:match("([^/]+)/([^/]+)/([^/]+)")
  if not contest_name or not problem_set or not problem_id then
    print("Unable to parse contest information.")
    return
  end


  -- 問題ID（例: `001`）を typical90 の場合のみアルファベット（例: `a`）に変換
  local problem_letter = ""
  if problem_set == "typical90" then
    -- 問題番号をアルファベットに変換する関数
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
    problem_letter = number_to_letter(problem_id)
  else
    -- `typical90` 以外はディレクトリ名そのものを使用
    problem_letter = problem_id
  end

  -- AtCoder の URL を生成
  local url = string.format("https://atcoder.jp/contests/%s/tasks/%s_%s", problem_set, problem_set, problem_letter)

  -- URL をブラウザで開く（macOS の `open`, Linux の `xdg-open`, Windows の `start` を利用）
  local open_command = "xdg-open" -- Linux
  if vim.loop.os_uname().sysname == "Darwin" then
    open_command = "open"         -- macOS
  elseif vim.loop.os_uname().sysname:match("Windows") then
    open_command = "start"        -- Windows
  end

  os.execute(open_command .. " " .. url)
end

vim.api.nvim_create_user_command("ProconOpenUrl", function()
  M.open_url()
end, {})

return M
