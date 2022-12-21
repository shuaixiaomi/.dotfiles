local M = {}

function M.visual_telescope()
  local search = require('lu5je0.core.visual').get_visual_selection_as_string()
  search = string.gsub(search, "'", '')
  search = string.gsub(search, '\n', '')

  -- require('telescope.builtin').live_grep {}

  print(search)
end

local theme = function(preview)
  local t = {
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      prompt = { "─", "│", " ", "│", '┌', '┐', "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    },
    width = 0.8,
    height = 50,
    results_height = 50,
    prompt_title = false,
    results_title = false,
    preview_title = false
  }
  if not preview then
    t.previewer = false
  end
  local r = require('telescope.themes').get_dropdown(t)
  r.layout_config.height = 20
  return r
end

local function key_mapping()
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<leader>fC', function()
    require('telescope.builtin').colorscheme(theme())
  end, opts)
  vim.keymap.set('n', '<leader>fc', function()
    require('telescope.builtin').commands(theme())
  end, opts)
  vim.keymap.set('n', '<leader>ff', function()
    require('telescope.builtin').find_files(theme())
  end, opts)
  vim.keymap.set('n', '<leader>fg', function()
    require('telescope.builtin').resume(theme())
  end, opts)
  vim.keymap.set('n', '<leader>fR', function()
    require('telescope.builtin').live_grep(theme(true))
  end, opts)
  vim.keymap.set('n', '<leader>fr', function()
    require('telescope.builtin').grep_string(vim.tbl_deep_extend('force', theme(true),
      { shorten_path = true, word_match = "-w", only_sort_text = true, search = '' }))
  end, opts)
  vim.keymap.set('n', '<leader>fb', function()
    require('telescope.builtin').buffers(theme())
  end, opts)
  vim.keymap.set('n', '<leader>fm', function()
    require('telescope.builtin').oldfiles(theme())
  end, opts)
  vim.keymap.set('n', '<leader>fh', function()
    require('telescope.builtin').help_tags(theme())
  end, opts)
  vim.keymap.set('n', '<leader>fl', function()
    require('telescope.builtin').current_buffer_fuzzy_find(theme())
  end, opts)
  vim.keymap.set('n', '<leader>fn', function()
    require('telescope.builtin').filetypes(theme())
  end, opts)
  vim.keymap.set('n', '<leader>fj', function()
    require('telescope.builtin').find_files(vim.tbl_deep_extend("force", theme(),
      { theme, search_dirs = { '~/junk-file' } }))
  end, opts)

  vim.keymap.set('x', '<leader>fr', M.visual_telescope, opts)
  -- vim.keymap.set('n', '<leader>fa', require('telescope').extensions.project.project, opts)
  -- vim.api.nvim_set_keymap('n', '<leader>fd', ':Telescope opener<cr>', opts)
end

function M.setup()
  local telescope = require('telescope')
  telescope.setup {
    defaults = {
      path_display = { truncate = 2 },
      layout_config = {
      },
    },
  }

  key_mapping()

  local group = vim.api.nvim_create_augroup('telescope', { clear = true })

  M.telescope_last_search = ''
  vim.api.nvim_create_autocmd('BufLeave', {
    group = group,
    pattern = { '*' },
    callback = function()
      if vim.o.buftype == 'prompt' then
        M.telescope_last_search = string.sub(vim.api.nvim_get_current_line(), 3, -1)
      end
    end
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = { 'TelescopePrompt' },
    callback = function()
      local opts = { noremap = true, silent = true, buffer = true, desc = 'telescope', nowait = true }

      if M.telescope_last_search ~= nil and M.telescope_last_search ~= "" then
        require('lu5je0.core.keys').feedkey(M.telescope_last_search)
        require('lu5je0.core.keys').feedkey('<esc>v$o^lloh<c-g>', 'n')
      end

      local bufnr = vim.api.nvim_win_get_buf(0)
      vim.keymap.set({ 'i', 'v' }, '<esc>', function()
        require('telescope.actions').close(bufnr)
      end, opts)

      vim.keymap.set({ 'v', 's' }, '<down>', function()
        require('telescope.actions').move_selection_next(bufnr)
      end, opts)

      vim.keymap.set({ 'v', 's' }, '<up>', function()
        require('telescope.actions').move_selection_previous(bufnr)
      end, opts)

      vim.keymap.set({ 'v', 's' }, '<cr>', function()
        require('telescope.actions').select_default(bufnr)
      end, opts)

      vim.keymap.set({ 'v', 's' }, '<bs>', '<c-g>c', opts)

      vim.keymap.set({ 'i' }, '<c-c>', function()
        require('lu5je0.core.keys').feedkey('<esc>', 'n')       
      end, opts)
      
    end
  })
end

return M
