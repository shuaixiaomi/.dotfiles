local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd('term git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local packer = require('packer')
packer.init {
  max_jobs = 15,
}

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('packer_reload_augroup', { clear = true }),
  pattern = { 'plugins.lua' },
  command = 'source <afile> | PackerCompile',
})

return packer.startup(function(use)
  _G.__defer_plugins = {}
  local origin_use = use

  local function inject_use(params)
    if params.defer then
      params.opt = true
      table.insert(_G.__defer_plugins, params[1]:match('/(.*)$'))
    end
    if params.on_compile then
      params.on_compile()
    end
  end

  local batch_use = function(arr)
    for _, v in ipairs(arr) do
      if type(v) == 'function' then
        v()
      else
        use(v)
      end
    end
  end

  use = function(...)
    if type(...) == 'table' then
      inject_use(...)
    end
    origin_use(...)
  end

  -- Speed up loading Lua modules in Neovim to improve startup time.
  use('lewis6991/impatient.nvim')

  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  use('nvim-lua/plenary.nvim')

  use {
    'MunifTanjim/nui.nvim',
    commit = '042cceb497cc4cfa3ae735a5e7bc01b4b6f19ef1'
  }

  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        override = {
          xml = {
            icon = '',
            color = '#e37933',
            name = 'Xml',
          },
        },
        default = true,
      }
    end,
  }

  use {
    'lu5je0/LeaderF',
    run = './install.sh',
    defer = true,
    -- cmd = {'Leaderf', 'Git'},
    config = function()
      require('lu5je0.ext.leaderf').setup()
    end,
  }

  -- telescope
  batch_use {
    -- {
    --   'nvim-telescope/telescope-fzf-native.nvim',
    --   run = 'make',
    -- },
    -- {
    --   'nvim-telescope/telescope.nvim',
    --   config = function()
    --     require('lu5je0.ext.telescope').setup(false)
    --   end,
    --   defer = true,
    --   after = 'telescope-fzf-native.nvim',
    --   -- requires = {
    --   --   { 'nvim-lua/plenary.nvim' },
    --   --   {
    --   --     'AckslD/nvim-neoclip.lua',
    --   --     config = function()
    --   --       require('neoclip').setup {
    --   --         default_register = '*',
    --   --       }
    --   --     end,
    --   --   },
    --   -- },
    --   -- keys = { '<leader>f' },
    -- }
  }

  use {
    'ojroques/vim-oscyank',
    config = function()
      vim.cmd("autocmd TextYankPost * execute 'OSCYankReg \"'")
    end,
    disable = (vim.fn.has('wsl') == 1 or vim.fn.has('mac') == 1),
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      -- {
      --   'nvim-lua/lsp-status.nvim',
      --   config = function()
      --     local lsp_status = require('lsp-status')
      --     lsp_status.register_progress()
      --   end
      -- }
    },
    config = function()
      require('lu5je0.ext.lualine')
    end,
  }

  use {
    'lu5je0/bufferline.nvim',
    config = function()
      vim.g.bufferline_separator = true
      require('lu5je0.ext.bufferline')
    end,
    -- branch = 'main',
    requires = { 'nvim-web-devicons' },
  }

  use { 'schickling/vim-bufonly' }

  use {
    'theniceboy/vim-calc',
    opt = true,
    fn = { 'Calc' },
  }

  use {
    'rootkiter/vim-hexedit',
    opt = true,
    ft = 'bin',
    fn = { 'hexedit#ToggleHexEdit' },
  }

  use {
    'sgur/vim-textobj-parameter',
    requires = {
      {
        'kana/vim-textobj-user',
        opt = true
      }
    },
    after = {
      'vim-exchange',
    },
    setup = function()
      vim.g.vim_textobj_parameter_mapping = 'a'
    end,
    keys = { { 'x', 'ia' }, { 'o', 'ia' }, { 'x', 'aa' }, { 'o', 'aa' }, { 'n', 'cxia' }, { 'n', 'cxaa' } }
  }

  use {
    'tommcdo/vim-exchange',
    keys = { { 'n', 'cx' } },
  }

  use {
    'othree/eregex.vim',
    opt = true,
    keys = { '/', '?' },
    setup = function()
      vim.g.eregex_default_enable = 0
    end,
    fn = { 'eregex#toggle' },
    cmd = 'S',
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
        opleader = {
          -- Line-comment keymap
          line = 'gc',
          -- Block-comment keymap
          block = 'gB',
        },
        toggler = {
          -- Line-comment toggle keymap
          line = 'gcc',
          -- Block-comment toggle keymap
          block = 'gcgc',
        },
      }
    end,
    keys = { { 'x', 'gc' }, { 'n', 'gc' } }
  }

  use('tpope/vim-repeat')

  use {
    'vim-scripts/ReplaceWithRegister',
    keys = { { 'x', 'gr' }, { 'n', 'gr' } },
  }

  use('lu5je0/vim-base64')

  -- themes
  batch_use {
    'sainnhe/sonokai',
    'sainnhe/gruvbox-material',
    {
      'sainnhe/edge',
      on_compile = function()
        vim.g.edge_better_performance = 1
        vim.g.edge_enable_italic = 0
        vim.g.edge_disable_italic_comment = 1
      end,
      config = function()
        vim.g.edge_loaded_file_types = { 'NvimTree' }
        vim.cmd [[
      hi! Folded guifg=#282c34 guibg=#5c6370
      hi MatchParen guifg=#ffef28
      ]]
      end
    },
    -- {
    --   'Mofiqul/vscode.nvim',
    --   config = function()
    --     vim.g.vscode_style = "dark"
    --   end
    -- }
  }

  use {
    'akinsho/toggleterm.nvim',
    branch = 'main',
    defer = true,
    commit = '62683d927dfd30dc68441a5811fdcb6c9f176c42',
    config = function()
      require('lu5je0.ext.terminal').setup()
    end,
  }

  -- fern
  batch_use {
    -- {
    --   'lambdalisue/fern-git-status.vim',
    --   setup = function ()
    --     vim.g.loaded_fern_git_status = 1
    --   end
    -- },
    {
      'lambdalisue/fern.vim',
      opt = true,
      cmd = { 'Fern', 'FernLocateFile' },
      fn = { 'FernLocateFile' },
      requires = {
        { 'lambdalisue/fern-hijack.vim' },
        { 'lambdalisue/nerdfont.vim' },
        { 'lu5je0/fern-renderer-nerdfont.vim' },
        { 'lambdalisue/glyph-palette.vim' },
        { 'yuki-yano/fern-preview.vim', opt = true },
      },
      config = function()
        vim.cmd('runtime plug-config/fern.vim')
      end,
    },
  }

  use {
    'mg979/vim-visual-multi',
    opt = true,
    setup = function()
      vim.cmd [[autocmd User visual_multi_mappings nmap <buffer> p "+<Plug>(VM-p-Paste)]]
      vim.g.VM_maps = {
        ['Select Cursor Down'] = '<m-n>',
        ['Remove Region'] = '<c-p>',
        ['Skip Region'] = '<c-x>'
      }
    end,
    keys = { '<c-n>', '<m-n>' },
  }

  -- git
  batch_use {
    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('lu5je0.ext.gitsigns').setup()
      end,
      event = 'BufRead',
    },
    {
      'tpope/vim-fugitive',
      opt = true,
      cmd = { 'Git', 'Gvdiffsplit', 'Gstatus', 'Gclog', 'Gread', 'help', 'translator' },
      fn = { 'fugitive#repo' },
    },
    {
      'rbong/vim-flog',
      cmd = 'Flogsplit',
      opt = true,
      requires = { { 'tpope/vim-fugitive' } },
    },
    {
      'mattn/vim-gist',
      config = function()
        vim.cmd("let github_user = 'lu5je0@gmail.com'")
        vim.cmd('let g:gist_show_privates = 1')
        vim.cmd('let g:gist_post_private = 1')
      end,
      requires = { 'mattn/webapi-vim' },
    }
  }

  use {
    'lu5je0/vim-translator',
    config = function()
      vim.g.translator_default_engines = { 'disk' }
    end,
  }

  use {
    'dstein64/vim-startuptime',
    opt = true,
    cmd = { 'StartupTime' },
  }

  use {
    'mbbill/undotree',
    opt = true,
    cmd = { 'UndotreeToggle' },
    config = function()
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  }

  use {
    'junegunn/vim-peekaboo',
  }

  use {
    'tpope/vim-surround',
    keys = { { 'n', 'cs' }, { 'n', 'cS' }, { 'n', 'ys' }, { 'n', 'ds' }, { 'x', 'S' } }
  }

  local nvim_colorizer_ft = { 'vim', 'lua', 'css', 'conf', 'tmux' }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup(nvim_colorizer_ft, { names = false })
    end,
    ft = nvim_colorizer_ft,
  }

  use {
    'lambdalisue/suda.vim',
    opt = true,
    cmd = { 'SudaRead', 'SudaWrite' },
  }

  use {
    'iamcco/markdown-preview.nvim',
    run = function()
      vim.fn['mkdp#util#install']()
    end,
    config = function()
      vim.g.mkdp_auto_close = 0
    end,
    ft = { 'markdown' },
  }

  use {
    'windwp/nvim-autopairs',
    defer = true,
    commit = '94d42cd1afd22f5dcf5aa4d9dbd9f516b04c892e',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  }

  use {
    'williamboman/mason.nvim',
    defer = true,
    config = function()
      require("mason").setup()
    end
  }

  -- treesitter
  batch_use {
    function()
      -- stylua: ignore
      _G.__ts_filtypes = { 'json', 'python', 'java', 'lua', 'c', 'vim', 'bash', 'go',
        'rust', 'toml', 'yaml', 'markdown', 'bash', 'http', 'typescript', 'javascript' }
    end,
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      opt = true,
      config = function()
        require('lu5je0.ext.treesiter')
      end,
      ft = _G.__ts_filtypes,
      requires = {
        {
          'm-demare/hlargs.nvim',
          config = function()
            require('hlargs').setup()
          end
        },
        -- {
        --   'nvim-treesitter/playground',
        --   run = 'TSInstall query'
        -- },
        {
          'SmiteshP/nvim-gps',
          config = function()
            require('nvim-gps').setup()
          end,
        },
      },
    },
    {
      'stevearc/aerial.nvim',
      config = function()
        require('lu5je0.ext.aerial')
      end,
      cmd = { 'AerialToggle' }
    }
  }

  -- lsp
  batch_use {
    {
      'williamboman/mason-lspconfig.nvim',
      after = 'mason.nvim',
      config = function()
        require('mason-lspconfig').setup {
          ensure_installed = {}
        }
      end,
    },
    {
      'neovim/nvim-lspconfig',
      after = {
        'mason-lspconfig.nvim',
        'lua-dev.nvim',
      },
      defer = true,
      config = function()
        require('lu5je0.ext.lspconfig.lsp').setup()
      end,
      requires = {
        {
          "glepnir/lspsaga.nvim",
          branch = "main",
          config = function()
            require('lu5je0.ext.lspsaga')
          end,
          opt = true,
        }
      }
    },
    {
      'hrsh7th/nvim-cmp',
      config = function()
        require('lu5je0.ext.cmp')
      end,
      defer = true,
      after = { 'nvim-lspconfig', 'nvim-autopairs' },
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        {
          'hrsh7th/vim-vsnip',
          config = function()
            require('lu5je0.ext.vsnip').setup()
          end,
        },
        'hrsh7th/cmp-vsnip',
      },
    },
    {
      'max397574/lua-dev.nvim'
    },
    {
      'jose-elias-alvarez/null-ls.nvim',
      after = 'nvim-lspconfig',
      config = function()
        if vim.fn.has('nvim-0.8') == 0 then
          require('lu5je0.ext.null-ls.null-ls')
        end
      end,
    },
    {
      'lu5je0/vim-illuminate',
      after = 'nvim-lspconfig',
      config = function()
        vim.g.Illuminate_delay = 0
        vim.cmd([[
      hi! illuminatedWord ctermbg=green guibg=#344134
      ]] )
        vim.defer_fn(function()
          vim.cmd([[
        augroup illuminated_autocmd
          autocmd!
        augroup END
        ]] )
        end, 0)
      end,
    },
  }

  -- use {
  --   'neoclide/coc.nvim',
  --   branch = 'release',
  --   config = function()
  --     vim.cmd('runtime plug-config/coc.vim')
  --   end
  -- }

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('lu5je0.ext.indent-blankline')
    end,
  }

  -- debug dap
  batch_use {
    --   {
    --     "rcarriga/nvim-dap-ui",
    --     requires = { "mfussenegger/nvim-dap" },
    --     config = function()
    --       require("dapui").setup()
    --       local dap, dapui = require("dap"), require("dapui")
    --       dap.listeners.after.event_initialized["dapui_config"] = function()
    --         dapui.open()
    --       end
    --       dap.listeners.before.event_terminated["dapui_config"] = function()
    --         dapui.close()
    --       end
    --       dap.listeners.before.event_exited["dapui_config"] = function()
    --         dapui.close()
    --       end
    --     end
    --   }
  }

  use {
    'puremourning/vimspector',
    config = function()
      require('lu5je0.ext.vimspector').setup()
    end,
    keys = { '<F10>', '<S-F10>' },
    fn = { 'vimspector#Launch', 'vimspector#Reset', 'vimspector#LaunchWithConfigurations' },
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    keys = { '<leader>e', '<leader>fe' },
    on_compile = function()
      require('lu5je0.ext.nvim-tree-hijack')
    end,
    opt = true,
    config = function()
      require('lu5je0.ext.nvimtree').setup()
    end,
  }

  use {
    'folke/which-key.nvim',
    config = function()
      require('lu5je0.ext.whichkey').setup()
    end,
    keys = { ',' },
    opt = true,
  }

  use {
    'Pocco81/HighStr.nvim',
    config = function()
      require('lu5je0.ext.highstr')
    end,
    keys = { '<f1>', '<f2>', '<f3>', '<f4>', '<f6>' }
  }

  use {
    'dstein64/nvim-scrollview',
    defer = true,
    config = function()
      require('lu5je0.ext.scrollview').setup()
    end
  }

  -- fold
  batch_use {
    { 'kevinhwang91/promise-async' },
    {
      'kevinhwang91/nvim-ufo',
      defer = true,
      config = function()
        require('lu5je0.ext.nvim-ufo')
      end,
    }
  }

  -- use {
  --   'mhartington/formatter.nvim',
  --   config = function()
  --     require('lu5je0.ext.formatter')
  --   end
  -- }

end)
