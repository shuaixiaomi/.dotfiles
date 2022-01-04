local M = {}

local function all_trim(s)
  return s:match('^%s*(.*)'):match('(.-)%s*$')
end

M.parse_line = function(args)
  local count = 10
  if #args ~= 0 then
    count = args[1]
  end

  local line = all_trim(vim.api.nvim_get_current_line())

  local crontab = ''

  for i, v in ipairs(line:split(' ')) do
    if i <= 5 then
      crontab = crontab .. ' ' .. v
    end
  end

  print(crontab)
  print(vim.fn.system('cron-parser -c ' .. count, crontab))
end

return M
