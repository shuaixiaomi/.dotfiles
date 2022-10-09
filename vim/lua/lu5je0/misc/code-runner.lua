---@diagnostic disable: missing-parameter

local M = {}
local expand = vim.fn.expand

local function build_cmd_with_file(cmd)
  return cmd .. ' ' .. expand('%:p')
end

local function execute_in_terminal(cmd, append_cmd)
  vim.api.nvim_command('silent write')
  if append_cmd ~= nil then
    cmd = cmd .. ' && ' .. append_cmd
  end
  require("lu5je0.ext.terminal").send_to_terminal(cmd, { go_back = 0 })
  if vim.bo.buftype == 'terminal' and vim.api.nvim_win_get_config(0).relative == '' then
    require('lu5je0.core.keys').feedkey('<c-q><c-w>p')
  end
end

local function special()
  local fullpath = expand("%:p")
  if vim.bo.filetype == 'lua' and fullpath == '/home/lu5je0/.dotfiles/wezterm/wezterm.lua' and vim.fn.has('wsl') == 1 then
    vim.api.nvim_command('silent write')
    vim.fn.system('cp ' .. fullpath .. ' ' .. '/mnt/c/Users/73995/.wezterm.lua"')
    print("copied to windows")
    return true
  end
  return false
end

M.run_curl = function()
  local filetype = vim.bo.filetype

  if vim.bo.modified then
    vim.cmd('w')
    print('save')
  end

  execute_in_terminal('source ~/work_proxy',build_cmd_with_file('sh') .. ';unset http_proxy;unset https_proxy')
end

M.run_file = function()
  local filetype = vim.bo.filetype

  if vim.bo.modified then
    vim.cmd('w')
    print('save')
  end

  if filetype == 'vim' then
    vim.cmd('so %')
  elseif filetype == 'lua' then
    if special() then
      return
    end
    if vim.g.lua_dev == 1 then
      vim.cmd('luafile %')
    else
      execute_in_terminal(build_cmd_with_file('luajit'))
    end
  elseif filetype == 'c' then
    execute_in_terminal(build_cmd_with_file('gcc'), './a.out && rm ./a.out')
  elseif filetype == 'javascript' then
    execute_in_terminal(build_cmd_with_file('node'))
  elseif filetype == 'go' then
    execute_in_terminal(build_cmd_with_file('go run'))
  elseif filetype == 'sh' then
    execute_in_terminal(build_cmd_with_file('sh'))
  elseif filetype == 'markdown' then
    vim.cmd('MarkdownPreview')
  elseif filetype == 'bash' or filetype == 'zsh' then
    execute_in_terminal(build_cmd_with_file('bash'))
  elseif filetype == 'python' then
    execute_in_terminal(build_cmd_with_file('python3'))
  elseif filetype == 'rust' then
    execute_in_terminal('cargo run')
  elseif filetype == 'typescript' then
    execute_in_terminal(build_cmd_with_file('ts-node'))
  elseif filetype == 'javascript' then
    execute_in_terminal(build_cmd_with_file('node'))
  elseif filetype == 'java' then
    execute_in_terminal(build_cmd_with_file('java'))
  end
end

M.key_mapping = function()
  local opts = {
    noremap = true,
    silent = false,
    desc = 'runner.lua'
  }
  vim.keymap.set('n', '<leader>rr', function()
    M.run_file()
  end, opts)
end

M.command = function()
  vim.api.nvim_create_user_command('RunFile', function()
    M.run_file()
  end, { force = true, nargs = '*' })

  vim.g.lua_dev = 1
  vim.cmd [[
  command! -nargs=0 LuaDevOn let g:lua_dev=1
  command! -nargs=0 LuaDevOff let g:lua_dev=0
  ]]
end

return M
