-- im
if vim.fn.has('gui') == 0 then
  if vim.fn.has('wsl') == 1 then
    require('lu5je0.misc.im.win.im').setup()
  elseif vim.fn.has('mac') == 1 then
    require('lu5je0.misc.im.mac.im').setup()
  end
end
-- require('lu5je0.misc.im.im_keeper').setup({
--   mac = false,
--   win = false,
--   interval = 300
-- })

-- json-helper
require('lu5je0.misc.json-helper').setup()

-- big-file
require('lu5je0.misc.big-file').setup {
  size = 1024 * 1024, -- 1000 KB
  features = {
    {
      function()
        vim.cmd [[ CmpAutocompleteDisable ]]
      end, 500 * 1024
    },
    function(buf_nr)
      vim.cmd [[ IndentBlanklineDisable ]]
      vim.treesitter.stop(buf_nr)
      require('hlargs').disable()
    end
  }
}

-- formatter
local formatter = require('lu5je0.misc.formatter.formatter')
formatter.setup {
  format_priority = {
    json = { formatter.FORMAT_TOOL_TYPE.LSP, formatter.FORMAT_TOOL_TYPE.EXTERNAL },
    [{ 'bash', 'sh' }] = { formatter.FORMAT_TOOL_TYPE.EXTERNAL, formatter.FORMAT_TOOL_TYPE.LSP },
  },
  external_formatter = {
    json = {
      format = function()
        vim.cmd [[ JsonFormat ]]
      end,
      range_format = function()
      end,
    },
    sql = {
      format = function()
        vim.cmd(':%!sql-formatter -l mysql')
      end,
      range_format = function()
      end,
    },
    [{ 'bash', 'sh' }] = {
      format = function()
        vim.cmd(':%!shfmt -i ' .. vim.bo.shiftwidth)
      end,
      range_format = function()
      end,
    }
  }
}

-- var-naming-converter
require('lu5je0.misc.var-naming-converter').key_mapping()

-- code-runner
require('lu5je0.misc.code-runner').key_mapping()

-- quit-prompt
require('lu5je0.misc.quit-prompt').setup()
