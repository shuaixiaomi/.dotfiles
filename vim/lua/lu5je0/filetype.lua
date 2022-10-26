---@diagnostic disable: unused-local

vim.filetype.add {
  extension = {
    zsh = 'bash',
  },
  filename = {
    ['.bashrc'] = 'bash',
    ['.zshrc'] = 'bash',
    ['zshrc'] = 'bash',
    ['bashrc'] = 'bash',
    ['.ohmyenv'] = 'bash',
    ['crontab'] = 'crontab',
    ['aria2.conf'] = 'dosini',
    ['requirements.txt'] = function(path, bufnr)
      vim.defer_fn(function()
        vim.bo[bufnr].commentstring='#%s'
      end, 0)
      return 'text'
    end
  },
  pattern = {
    ['.*%.tmux.conf'] = 'tmux',
  },
}
