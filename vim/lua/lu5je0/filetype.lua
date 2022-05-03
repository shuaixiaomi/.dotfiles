vim.filetype.add {
  extension = {
    zsh = 'sh',
  },
  filename = {
    -- Set the filetype of files named "MyBackupFile" to lua
    ['.bashrc'] = 'sh',
    ['.zshrc'] = 'sh',
    ['zshrc'] = 'sh',
    ['bashrc'] = 'sh',
    ['.ohmyenv'] = 'sh',
    ['crontab'] = 'crontab',
  },
  pattern = {
    ['.*%.tmux.conf'] = 'tmux',
  },
}
