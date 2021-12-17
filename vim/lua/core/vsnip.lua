local M = {}

M.setup = function()
  vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/snippets/vsnip'
  vim.cmd[[
  nmap <silent> <expr> <cr> v:lua.require('core.vsnip').jump_next_able() ? 'i<Plug>(vsnip-jump-next)' : 'j^'
  nmap <m-r> <cr>
  ]]
end

M.jump_next_able = function()
  return vim.fn.line("'^") == vim.fn.line(".") and vim.fn['vsnip#jumpable'](1) == 1
end

return M
