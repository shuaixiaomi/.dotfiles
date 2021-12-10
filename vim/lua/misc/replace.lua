local M = {}

local function replace(mode)
  vim.cmd("mark `")
  local target = vim.fn.input("replace with:")

  if target == nil or target == "" then
    return
  end

  local source = nil
  if mode == "n" then
    source = vim.fn.expand("<cword>")
  elseif mode == "v" then
    source = vim.call('visual#visual_selection')
  end

  source = string.gsub(source, "\\", "\\\\")
  source = string.gsub(source, "/", "\\/")
  target = require('misc/vim_escape').escape(target)

  local r = ":%s/" .. source .. "/" .. target .. "/g"
  vim.cmd(r)
  vim.cmd("normal ``")
end

function M.v_replace()
  replace("v")
end

function M.n_replace()
  replace("n")
end

return M
