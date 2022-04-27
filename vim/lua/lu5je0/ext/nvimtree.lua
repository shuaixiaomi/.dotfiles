local M = {}

M.loaded = true

local lib = require('nvim-tree.lib')

function M.locate_file()
  if not M.loaded then
    vim.cmd('sleep 150m')
    M.loaded = true
  end

  local pwd = vim.fn.getcwd()

  -- current file path
  local cur_file_path = vim.fn.expand('%:p')

  if cur_file_path == nil or cur_file_path == '' then
    return
  end

  -- if pwd has .
  cur_file_path = string.sub(cur_file_path, 0, cur_file_path:match('^.*()/') - 1)

  if string.match(string.sub(cur_file_path, string.len(pwd) + 2, -1), [[%.]]) ~= nil then
    require('nvim-tree.actions.toggles').dotfiles()
  end

  if not string.startswith(cur_file_path, pwd) then
    vim.cmd(':cd ' .. cur_file_path)
  end
  vim.cmd('NvimTreeFindFile')
end

M.pwd_stack = require('lu5je0.lang.stack'):create()
M.pwd_forward_stack = require('lu5je0.lang.stack'):create()
M.pwd_back_state = 0

function M.terminal_cd()
  local cmd = 'cd ' .. vim.fn.fnamemodify(require('nvim-tree.lib').get_node_at_cursor().absolute_path, ':p:h')
  require('lu5je0.ext.terminal').send_to_terminal(cmd)
end

function M.remove()
  local bufs = require("lu5je0.core.buffers").invild_buffers()
  -- local bufs = vim.api.nvim_list_bufs()

  local is_remove_cur_file = false
  local cur_file_win_id = nil
  for _, win_id in pairs(vim.api.nvim_list_wins()) do
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    if vim.fn.buflisted(buf_id) then
      local path = vim.fn.expand("#" .. tostring(buf_id) .. ":p")
      if path == lib.get_node_at_cursor().absolute_path then
        is_remove_cur_file = true
        cur_file_win_id = win_id
        break
      end
    end
  end

  -- try to get substitute file when remove cur file
  local substitute_buf_id = nil
  if is_remove_cur_file then
    for _, buf_id in pairs(bufs) do
      if vim.fn.buflisted(buf_id) then
        if vim.bo[buf_id].filetype == 'NvimTree' then
          goto continue
        end
        local path = vim.fn.expand("#" .. tostring(buf_id) .. ":p")
        if path ~= lib.get_node_at_cursor().absolute_path
          and vim.bo[buf_id].buftype == ''
          and not string.find(path, 'undotree')
        then
          substitute_buf_id = buf_id
          break
        end
      end
      ::continue::
    end
  end

  if is_remove_cur_file and substitute_buf_id ~= nil then
    vim.api.nvim_win_set_buf(cur_file_win_id, substitute_buf_id)
  end
  local cur_width = vim.api.nvim_win_get_width(0)
  require('nvim-tree.actions').on_keypress('remove')
  if is_remove_cur_file and substitute_buf_id == nil then
    vim.cmd("vnew")
    vim.cmd('NvimTreeResize ' .. cur_width)
    require('lu5je0.core.keys').feedkey('<c-w>p', '')
  end
end

function M.edit()
  if _G.preview_popup then
    _G.preview_popup:unmount()
  end
  require('nvim-tree.actions').on_keypress('edit')
end

function M.pwd_stack_push()
  M.pwd_stack:push(vim.fn.getcwd())
end

function M.back()
  if M.pwd_stack:count() >= 2 then
    M.pwd_back_state = 1
    M.pwd_forward_stack:push(M.pwd_stack:pop())
    vim.cmd(':cd ' .. M.pwd_stack:pop())
    M.pwd_back_state = 0
  end
end

function M.forward()
  if M.pwd_forward_stack:count() >= 1 then
    vim.cmd(':cd ' .. M.pwd_forward_stack:pop())
  end
end

function M.cd()
  require('nvim-tree.actions').on_keypress('cd')
  -- local lib = require('nvim-tree.lib')
  -- if lib ~= nil then
  --   vim.cmd(':cd ' .. vim.fn.fnamemodify(lib.get_node_at_cursor().absolute_path, ':p:h'))
  -- end
  vim.cmd('norm gg')
end

function M.preview()
  local path = lib.get_node_at_cursor().absolute_path
  if vim.fn.isdirectory(path) == 1 then
    return
  end
  require('lu5je0.core.ui').preview(path)
end

function M.file_info()
  local info = vim.fn.system('ls -alhd "' .. lib.get_node_at_cursor().absolute_path .. '" -l --time-style="+%Y-%m-%d %H:%M:%S"')
  info = info .. vim.fn.system('du -h --max-depth=0 "' .. lib.get_node_at_cursor().absolute_path .. '"'):sub(1, -2)
  require('lu5je0.core.ui').popup_info_window(info)
end

function M.open_node()
  local node = lib.get_node_at_cursor()
  if not node.open and (node.has_children or (node.nodes and #node.nodes ~= 0)) then
    vim.schedule(function()
      vim.cmd('norm j')
    end)
  end
  require('nvim-tree.actions').on_keypress('edit')
end

function M.close_node()
  local node = lib.get_node_at_cursor()
  if node.open then
    require('nvim-tree.actions').on_keypress('edit')
  else
    require('nvim-tree.actions').on_keypress('close_node')
  end
end

function M.toggle_width()
  local cur_width = vim.api.nvim_win_get_width(0)
  local after_width = math.floor(vim.api.nvim_eval('&co') * 2 / 5)

  if M.last_width == nil or cur_width ~= after_width then
    vim.cmd('NvimTreeResize ' .. after_width)
    M.last_width = cur_width
    vim.cmd('vertical resize ' .. after_width)
  else
    vim.cmd('NvimTreeResize ' .. M.last_width)
    vim.cmd('vertical resize ' .. M.last_width)
  end
end

function M.increase_width(w)
  vim.cmd('vertical resize +' .. w)

  local width = vim.api.nvim_win_get_width(vim.api.nvim_get_current_win())
  vim.cmd('NvimTreeResize ' .. (width + w))
end

function M.reduce_width(w)
  vim.cmd('vertical resize -' .. w)

  local width = vim.api.nvim_win_get_width(vim.api.nvim_get_current_win())
  vim.cmd('NvimTreeResize ' .. (width - w))
end

function M.setup()
  vim.g.nvim_tree_icons = {
    default = '',
    symlink = '',
    git = {
      unstaged = '✗',
      staged = '✓',
      unmerged = '',
      renamed = '➜',
      untracked = '★',
      deleted = '',
      ignored = '◌',
    },
    actions = {
      change_dir = {
        enable_dir = {
          enable = false,
          global = true,
        },
      },
    },
    folder = {
      arrow_open = ' ',
      arrow_closed = ' ',
      default = '',
      open = '',
      empty = '',
      empty_open = '',
      symlink = '',
      symlink_open = '',
    },
  }
  vim.g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
  }
  vim.g.nvim_tree_special_files = {}
  vim.g.nvim_tree_add_trailing = 1
  vim.g.nvim_tree_create_in_closed_folder = 1

  vim.cmd([[
    hi NvimTreeFolderName guifg=#e5c07b
    hi Directory ctermfg=107 guifg=#61afef
    hi NvimTreeOpenedFolderName guifg=#e5c07b
    hi default link NvimTreeFolderIcon Directory
    hi NvimTreeEmptyFolderName guifg=#e5c07b
    hi NvimTreeRootFolder guifg=#e06c75
    hi NvimTreeGitDirty guifg=#e06c75

    autocmd DirChanged * lua require('lu5je0.ext.nvimtree').pwd_stack_push()

    function! NvimLocateFile()
      PackerLoad nvim-tree.lua
      lua require("lu5je0.ext.nvimtree").locate_file()
    endfunction

    lua vim.api.nvim_set_keymap('n', '<leader>fe', ':call NvimLocateFile()<cr>', { noremap = true, silent = true })
  ]])

  vim.cmd([[
  augroup nvim_tree_group
      autocmd!
      autocmd BufWinEnter NvimTree_* setlocal cursorline
  augroup END
  ]])

  local opts = {
    noremap = true,
    silent = true,
    desc = 'nvim_tree'
  }
  vim.keymap.set('n', '<leader>e', function()
    require('nvim-tree').toggle(false, true)
  end, opts)
  vim.keymap.set('n', '<leader>fe', require('lu5je0.ext.nvimtree').locate_file, opts)
  vim.api.nvim_set_keymap('n', '<leader>fp', ':cd ~/.local/share/nvim/site/pack/packer<cr>', opts)
  vim.api.nvim_set_keymap('n', '<leader>fd', ':cd ~/.dotfiles<cr>', opts)

  local view = require('nvim-tree.view')
  view.View.winopts.signcolumn = 'no'
  view.View.winopts.foldcolumn = 1

  -- default mappings
  local list = {
    -- { key = { '<CR>', 'l', 'o', '<2-LeftMouse>' }, cb = ":lua require('lu5je0.ext.nvimtree').edit()<cr>" },
    { key = { 'cd', 'C' }, cb = ":lua require('lu5je0.ext.nvimtree').cd()<cr>" },
    { key = { 't' }, cb = ":lua require('lu5je0.ext.nvimtree').terminal_cd()<cr>" },
    { key = '=', cb = ":lua require('lu5je0.ext.nvimtree').increase_width(2)<cr>" },
    { key = '-', cb = ":lua require('lu5je0.ext.nvimtree').reduce_width(2)<cr>" },
    { key = '+', cb = ":lua require('lu5je0.ext.nvimtree').increase_width(1)<cr>" },
    { key = '_', cb = ":lua require('lu5je0.ext.nvimtree').reduce_width(1)<cr>" },
    { key = 'p', cb = ":lua require('lu5je0.ext.nvimtree').preview()<cr>" },
    { key = 'x', cb = ":lua require('lu5je0.ext.nvimtree').toggle_width()<cr>" },
    { key = 'D', cb = ":lua require('lu5je0.ext.nvimtree').remove()<cr>" },
    { key = 'l', cb = ":lua require('lu5je0.ext.nvimtree').open_node()<cr>" },
    { key = 'h', cb = ":lua require('lu5je0.ext.nvimtree').close_node()<cr>" },
    { key = 'H', cb = ':cd ~<cr>' },
    { key = 'd', cb = '<nop>' },
    { key = 's', action = 'vsplit' },
    { key = 'S', action = 'search_node' },
    -- { key = 's', action = 'split' },
    -- { key = "<C-t>", cb = tree_cb("tabnew") },
    { key = '<', action = 'prev_sibling' },
    { key = '>', action = 'next_sibling' },
    -- { key = 'f', cb = ":lua require('lu5je0.ext.nvimtree').file_info()<cr>" },
    { key = 'f', action = 'toggle_file_info' },
    { key = '.', action = 'run_file_command' },
    -- { key = 'P', action = 'parent_node' },
    -- { key = { '<BS>', 'h' }, action = 'close_node' },
    { key = 'K', action = 'first_sibling' },
    { key = 'J', action = 'last_sibling' },
    -- { key = "I", cb = tree_cb("toggle_ignored") },
    { key = 'I', action = 'toggle_dotfiles' },
    { key = 'r', action = 'refresh' },
    { key = 'ma', action = 'create' },
    { key = 'mv', action = 'rename' },
    -- { key = "mv", cb = tree_cb("cut") },
    { key = 'yy', action = 'copy' },
    { key = 'P', action = 'paste' },
    { key = 'yn', action = 'copy_name' },
    { key = 'yP', action = 'copy_path' },
    { key = 'yp', action = 'copy_absolute_path' },
    { key = '[g', action = 'prev_git_item' },
    { key = ']g', action = 'next_git_item' },
    { key = 'u', action = 'dir_up' },
    { key = 'o', action = 'system_open' },
    { key = 'q', action = 'close' },
    { key = 'g?', action = 'toggle_help' },
    { key = '<c-o>', action = 'backward', action_cb = M.back },
    { key = { '<tab>', '<c-i>' }, action = 'forward', action_cb = M.forward },
  }

  require('nvim-tree').setup {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = true,
    diagnostics = {
      enable = false,
      icons = {
        hint = '',
        info = '',
        warning = '',
        error = '',
      },
    },
    update_focused_file = {
      enable = false,
      update_cwd = false,
      ignore_list = {},
    },
    actions = {
      change_dir = {
        enable = true,
        global = true,
      },
    },
    git = {
      enable = true,
      ignore = false,
      timeout = 500,
    },
    system_open = {
      cmd = nil,
      args = {},
    },
    filters = {
      dotfiles = true,
      custom = {},
    },
    renderer = {
      indent_markers = {
        enable = true,
      },
    },
    view = {
      width = 27,
      height = 30,
      hide_root_folder = false,
      side = 'left',
      mappings = {
        custom_only = true,
        list = list,
      },
      signcolumn = 'auto',
    },
  }

  vim.g.nvim_tree_window_picker_exclude = {
    filetype = { 'notify', 'packer', 'qf', 'confirm', 'popup' },
    buftype = { 'terminal', 'nowrite' },
  }

  M.pwd_stack:push(vim.fn.getcwd())
  M.loaded = true
end

return M
