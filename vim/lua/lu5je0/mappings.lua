vim.g.mapleader = ','

-- option toggle
local option_toggler = require('lu5je0.misc.option-toggler')
local default_opts = { desc = 'mappings.lua', silent = true }

local function del_map(modes, lhs, opts)
  if type(lhs) == 'table' then
    for _, v in ipairs(lhs) do
      vim.keymap.del(modes, v, opts)
    end
  else
    vim.keymap.del(modes, lhs, opts)
  end
end

local function set_map(modes, lhs, rhs, opts)
  if opts == nil then
    opts = default_opts
  end
  
  if type(rhs) == 'table' then
    for _, v in ipairs(lhs) do
      vim.keymap.set(modes, v, rhs, default_opts)
    end
  else
    vim.keymap.set(modes, lhs, rhs, default_opts)
  end
end

local set_n_map = function(...) set_map('n', ...) end
local set_x_map = function(...) set_map('x', ...) end

vim.defer_fn(function()
  -- movement
  set_map({ 'x', 'n', 'o' }, 'H', '^')
  set_map({ 'x', 'n', 'o' }, 'L', '$')

  -- toggle
  set_n_map('<leader>vn', option_toggler.new_toggle_fn({ 'set nonumber', 'set number' }))
  set_n_map('<leader>vp', option_toggler.new_toggle_fn({ 'set nopaste', 'set paste' }))
  set_n_map('<leader>vm', option_toggler.new_toggle_fn({ 'set mouse=c', 'set mouse=a' }))
  set_n_map('<leader>vs', option_toggler.new_toggle_fn({ 'set signcolumn=no', 'set signcolumn=yes:1' }))
  set_n_map('<leader>vl', option_toggler.new_toggle_fn({ 'set cursorline', 'set nocursorline' }))
  set_n_map('<leader>vf', option_toggler.new_toggle_fn({ 'set foldcolumn=auto:9', 'set foldcolumn=0' }))
  set_n_map('<leader>vd', option_toggler.new_toggle_fn({ 'windo difft', 'windo diffo' }))
  set_n_map('<leader>vh', option_toggler.new_toggle_fn({ 'call hexedit#ToggleHexEdit()' }))
  set_n_map('<leader>vc', option_toggler.new_toggle_fn({ 'set noignorecase', 'set ignorecase' }))
  set_n_map('<leader>vi', option_toggler.new_toggle_fn(function() vim.fn['ToggleSaveLastIme']() end))
  set_n_map('<leader>vw', function()
    local buffer_opts = vim.deepcopy(default_opts)
    buffer_opts.buffer = true
    if vim.wo.wrap then
      vim.wo.wrap = false
      del_map({ 'x', 'n' }, { 'j', 'k' }, { buffer = 0 })
      del_map({ 'x', 'n', 'o' }, { 'H', 'L' }, { buffer = 0 })
      del_map({ 'o' }, 'Y', { buffer = 0 })
    else
      vim.wo.wrap = true
      set_map({ 'x', 'n' }, 'j', 'gj', buffer_opts)
      set_map({ 'x', 'n' }, 'k', 'gk', buffer_opts)
      set_map({ 'x', 'n', 'o' }, 'H', 'g^', buffer_opts)
      set_map({ 'x', 'n', 'o' }, 'L', 'g$', buffer_opts)
      set_map({ 'o' }, 'Y', 'gyg$', buffer_opts)
    end
  end)
  
  -- ctrl-c 复制
  set_x_map('<C-c>', 'y')
  
  vim.cmd [[
  nmap Q <cmd>execute 'normal @' .. reg_recorded()<CR>

  " 缩进后重新选择
  xmap < <gv
  xmap > >gv

  imap <M-j> <down>
  imap <M-k> <up>
  imap <M-h> <left>
  imap <M-l> <right>

  map <silent> <m-cr> <leader>cc
  imap <silent> <m-cr> <leader>cc
  map <silent> <d-cr> <leader>cc
  imap <silent> <d-cr> <leader>cc

  " visual-multi
  map <c-d-n> <Plug>(VM-Add-Cursor-Down)
  map <c-d-p> <Plug>(VM-Add-Cursor-Up)
  map <c-m-n> <Plug>(VM-Add-Cursor-Down)
  map <c-m-p> <Plug>(VM-Add-Cursor-Up)

  "----------------------------------------------------------------------
  " <leader>
  "----------------------------------------------------------------------
  nmap <silent> <leader>tN :tabnew<cr>

  "----------------------------------------------------------------------
  " window control
  "----------------------------------------------------------------------
  " 快速切换窗口
  nmap <silent> <c-j> <c-w>j
  nmap <silent> <c-k> <c-w>k
  nmap <silent> <c-h> <c-w>h
  nmap <silent> <c-l> <c-w>l

  nmap <silent> <left> :bp<cr>
  nmap <silent> <right> :bn<cr>
  nmap <silent> <c-b>o <c-w>p
  nmap <silent> <c-b><c-o> <c-w>p

  " 打断undo
  inoremap . <c-g>u.

  "----------------------------------------------------------------------
  " text-objects
  "----------------------------------------------------------------------
  onoremap il :<c-u>normal! v$o^oh<cr>
  xnoremap il $o^oh

  onoremap ie :<c-u>normal! vgg0oG$<cr>
  xnoremap ie gg0oG$

  onoremap ae :<c-u>normal! vgg0oG$<cr>
  xnoremap ae gg0oG$

  "----------------------------------------------------------------------
  " visual mode
  "----------------------------------------------------------------------
  xmap <silent> # :lua require("ext.terminal").run_select_in_terminal()<cr>

  "----------------------------------------------------------------------
  " other
  "----------------------------------------------------------------------
  nnoremap * m`:keepjumps normal! *``<cr>
  xnoremap * m`:keepjumps <C-u>call visual#star_search_set('/')<CR>/<C-R>=@/<CR><CR>``
  nnoremap v m'v
  nnoremap V m'V

  "----------------------------------------------------------------------
  " leader
  "----------------------------------------------------------------------
  nmap <leader>% :%s/

  nmap <leader>wo <c-w>o

  " Echo translation in the cmdline
  nmap <silent> <Leader>sc <Plug>Translate
  xmap <silent> <Leader>sc <Plug>TranslateV

  " say it
  nmap <silent> <Leader>sa :call misc#say_it()<cr><Plug>TranslateW
  xmap <silent> <Leader>sa :call misc#visual_say_it()<cr><Plug>TranslateWV

  " xmap <silent> <Leader>sc <Plug>TranslateV
  " Display translation in a window
  nmap <silent> <Leader>ss <Plug>TranslateW
  xmap <silent> <Leader>ss <Plug>TranslateWV
  " Replace the text with translation
  nmap <silent> <Leader>sr <Plug>TranslateR
  xmap <silent> <Leader>sr <Plug>TranslateRV

  "----------------------------------------------------------------------
  " 繁体简体
  "----------------------------------------------------------------------
  xmap <leader>xz :!opencc -c t2s<cr>
  nmap <leader>xz :%!opencc -c t2s<cr>
  xmap <leader>xZ :!opencc -c s2t<cr>
  nmap <leader>xZ :%!opencc -c s2t<cr>

  "----------------------------------------------------------------------
  " base64
  "----------------------------------------------------------------------
  xmap <silent> <leader>xB :<c-u>call base64#v_atob()<cr>
  xmap <silent> <leader>xb :<c-u>call base64#v_btoa()<cr>

  "----------------------------------------------------------------------
  " unicode escape
  "----------------------------------------------------------------------
  xmap <silent> <leader>xu :<c-u>call visual#replace_by_fn("UnicodeEscapeString")<cr>
  xmap <silent> <leader>xU :<c-u>call visual#replace_by_fn("UnicodeUnescapeString")<cr>

  "----------------------------------------------------------------------
  " text escape
  "----------------------------------------------------------------------
  xmap <silent> <leader>xs :<c-u>call visual#replace_by_fn("EscapeText")<cr>
  " xmap <silent> <leader>xU :<c-u>call visual#replace_by_fn("UnicodeUnescapeString")<cr>

  "----------------------------------------------------------------------
  " url encode
  "----------------------------------------------------------------------
  nmap <leader>xh :%!python -c 'import sys,urllib;print urllib.quote(sys.stdin.read().strip())'<cr>
  nmap <leader>xH :%!python -c 'import sys,urllib;print urllib.unquote(sys.stdin.read().strip())'<cr>

  xmap <silent> <leader>cc <Plug>(coc-codeaction-selected)<cr>
  nmap <silent> <leader>cc <Plug>(coc-codeaction-selected)<cr>

  xmap <leader>xh :!python -c 'import sys,urllib;print urllib.quote(sys.stdin.read().strip())'<cr>
  xmap <leader>xH :!python -c 'import sys,urllib;print urllib.unquote(sys.stdin.read().strip())'<cr>

  " ugly hack to start newline and keep indent
  nnoremap <silent> o o<space><bs>
  nnoremap <silent> O O<space><bs>
  inoremap <silent> <cr> <cr><space><bs>

  "----------------------------------------------------------------------
  " command line map
  "----------------------------------------------------------------------
  cmap <c-a> <c-b>
  ]]

end, 0)
