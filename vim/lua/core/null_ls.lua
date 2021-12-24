local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    require('null-ls').builtins.formatting.stylua.with({
      extra_args = { '--config-path', vim.fn.stdpath('config') .. '/config/stylua.toml' },
    }),
    require('null-ls').builtins.formatting.autopep8,
    -- require("null-ls").builtins.code_actions.refactoring
    -- require("null-ls").builtins.diagnostics.eslint,
    -- require("null-ls").builtins.completion.spell,
  },
})

local trailing_space = {
  -- method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { 'vim', 'python', 'bash', 'c', 'java', 'sh', 'zsh' },
  generator = {
    fn = function(params)
      local diagnostics = {}
      -- sources have access to a params object
      -- containing info about the current file and editor state
      for i, line in ipairs(params.content) do
        if line:find('[^ ]') then
          local col, end_col = line:find(' +$')
          if col and end_col then
            -- null-ls fills in undefined positions
            -- and converts source diagnostics into the required format
            table.insert(diagnostics, {
              row = i,
              col = col,
              end_col = end_col + 1,
              source = 'trailing_space',
              message = 'trailing space',
              severity = 4,
            })
          end
        end
      end
      return diagnostics
    end,
  },
}
null_ls.register(trailing_space)
