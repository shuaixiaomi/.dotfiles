local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  vim.cmd("term git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)
end

local packer = require('packer')
packer.init {
  max_jobs = 15
}

vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])

-- Only required if you have packer configured as `opt`
return packer.startup(function()

  local use = packer.use

  -- Speed up loading Lua modules in Neovim to improve startup time.
  use 'lewis6991/impatient.nvim'

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  vim.g.did_load_filetypes = 1
  use {
    "nathom/filetype.nvim"
  }

  -- Use specific branch, dependency and run lua file after load
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require("config/galaxyline") end,
  }

  use {
    'hrsh7th/vim-eft',
    config = function()
      vim.cmd([[
      nmap ; <Plug>(eft-repeat)
      xmap ; <Plug>(eft-repeat)

      nmap f <Plug>(eft-f)
      xmap f <Plug>(eft-f)
      omap f <Plug>(eft-f)
      nmap F <Plug>(eft-F)
      xmap F <Plug>(eft-F)
      omap F <Plug>(eft-F)

      nmap t <Plug>(eft-t)
      xmap t <Plug>(eft-t)
      omap t <Plug>(eft-t)
      nmap T <Plug>(eft-T)
      xmap T <Plug>(eft-T)
      omap T <Plug>(eft-T)
      ]])
    end
  }

  use {
    'lu5je0/bufferline.nvim',
    config = function() require("config/bufferline") end
  }

  use 'kyazdani42/nvim-web-devicons'

  use {
    'jiangmiao/auto-pairs',
    config = function()
      vim.cmd([[let g:AutoPairs= {'(':')', '[':']', '{':'}',"'":"'",'"':'"', "`":"`", '```':'```', '"""':'"""', "'''":"'''"}]])
      vim.g.AutoPairsShortcutToggle = ''
      vim.g.AutoPairsShortcutJump = ''
      vim.g.AutoPairsShortcutFastWrap = ''
      vim.g.AutoPairsMoveCharacter = ''
    end
  }

  use {'schickling/vim-bufonly'}

  use {
    'theniceboy/vim-calc',
    opt = true,
    fn = {'Calc'}
  }

  use {
    'rootkiter/vim-hexedit',
    opt = true,
    ft = 'bin',
    fn = {'hexedit#ToggleHexEdit'}
  }

  use {
    'mattn/vim-gist',
    config = function()
      vim.cmd("let github_user = 'lu5je0@gmail.com'")
      vim.cmd("let g:gist_show_privates = 1")
      vim.cmd("let g:gist_post_private = 1")
    end
  }

  use {'mattn/webapi-vim'}

  -- use {'kyazdani42/nvim-tree.lua'}

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    opt = true,
    ft = {'json', 'python', 'java', 'lua', 'c', 'vim', 'bash', 'go', 'rust', 'toml', 'yaml', 'markdown', 'bash', 'sh'},
    config = function()
      require('config/treesiter')
    end
  }

  use {'chr4/nginx.vim'}
  use {'cespare/vim-toml'}

  use {
    'elzr/vim-json',
    config = function() vim.cmd('let g:vim_json_syntax_conceal = 0') end
  }

  use {'lu5je0/vim-java-bytecode'}

  use {'MTDL9/vim-log-highlighting'}

  use {
    'tpope/vim-dadbod',
    config = function ()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 30
    end,
    opt = true,
    cmd = {'DB', 'DBUI'}
  }

  use {
    'kristijanhusak/vim-dadbod-ui',
    opt = true,
    cmd = {'DB', 'DBUI'}
  }

  --   use {
  --       'SirVer/ultisnips',
  --       opt = true,
  --       ft = 'markdown',
  --       config = function() vim.cmd('let g:UltiSnipsExpandTrigger="<c-d>"') end
  --   }

  use {
    'othree/eregex.vim',
    opt = true,
    keys = {'/', '?'},
    setup = function()
      vim.g.eregex_default_enable = 0
    end,
    fn = {'eregex#toggle'},
    cmd = 'S'
  }

  use 'yianwillis/vimcdoc'

  use {
    'tpope/vim-commentary'
  }

  use 'lu5je0/vim-snippets'
  use 'kana/vim-textobj-user'
  use 'tpope/vim-repeat'

  use {
    'vim-scripts/ReplaceWithRegister',
    keys = {'gr'}
  }

  use 'tommcdo/vim-exchange'
  use 'lu5je0/vim-base64'

  -- themes
  use 'tomasiser/vim-code-dark'
  use 'lu5je0/vim-one'
  use 'gruvbox-community/gruvbox'
  use 'hzchirs/vim-material'
  use 'ayu-theme/ayu-vim'
  use 'w0ng/vim-hybrid'
  use 'glepnir/zephyr-nvim'

  local wsl_version = vim.api.nvim_eval('platform#is_wsl()')
  if  wsl_version == 1 or wsl_version == 2 then
    use {
      'lu5je0/im-switcher',
      opt = true
    }
  end

  -- " fern
  use {'lambdalisue/fern-hijack.vim'}

  use {
    'lambdalisue/fern.vim',
    opt = true,
    fn = {'FernLocateFile'},
    cmd = {'Fern'},
    requires = {
      {'yuki-yano/fern-preview.vim', opt = true},
      {'lambdalisue/nerdfont.vim', opt = true},
      {'lu5je0/fern-renderer-nerdfont.vim', opt = true},
      {'lambdalisue/glyph-palette.vim', opt = true},
      {'lambdalisue/fern-git-status.vim', opt = true}
    },
    config = function() vim.cmd('runtime plug-config/fern.vim') end
  }

  use {'Yggdroot/LeaderF',
      run = './install.sh',
      opt = true,
      cmd = {'Leaderf', 'Git'},
      config = function() vim.cmd('runtime plug-config/leaderf.vim') end,
      requires = {
        {'linjiX/LeaderF-git'},
        {'tpope/vim-fugitive'}
      }
  }

  use {
    'mg979/vim-visual-multi',
    opt = true,
    setup = function ()
      vim.cmd [[
        let g:VM_maps = {}
        let g:VM_maps["Select Cursor Down"] = '<m-n>'
      ]]
    end,
    keys = {'<c-n>', '<m-n>'}
  }

  use {
    'sgur/vim-textobj-parameter',
    setup = function ()
      vim.g.vim_textobj_parameter_mapping = 'a'
    end,
    opt = true
  }

  -- use {
  --   'mhinz/vim-signify',
  --   config = function()
  --     vim.cmd("let g:signify_skip = {'vcs': { 'allow': ['git'] }}")
  --     vim.cmd("let g:signify_vcs_cmds_diffmode = {'git': 'git cat-file -p :./%f'}")
  --   end
  -- }
  --

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function ()
      require("config/gitsigns").setup()
    end,
    event = "BufRead"
  }

  use {
    'lu5je0/vim-translator',
    config = function()
      vim.g.translator_default_engines = {'disk'}
    end
  }

  use {
    'rbong/vim-flog',
    cmd = 'Flogsplit',
    opt = true,
    requires = {
      {
        'tpope/vim-fugitive',
        opt = true,
        cmd = {'Git', 'Gvdiffsplit', 'Gstatus'},
        requires = {
          {'skywind3000/asynctasks.vim', opt = true},
        }
      }
    }
  }

  use {
    'dstein64/vim-startuptime',
    opt = true,
    cmd = {'StartupTime'}
  }

  use {
    'lu5je0/vim-terminal-help',
    config = function() vim.cmd('runtime plug-config/terminal.vim') end,
    opt = true,
    keys = {'<m-i>', '<d-i>'},
    fn = {'TerminalSendInner', 'TerminalOpen', 'TerminalSend'}
  }

  use {
    'skywind3000/asyncrun.vim',
    opt = true,
    cmd = 'AsyncRun',
    requires = {
      {'skywind3000/asynctasks.vim', opt = true},
      {'skywind3000/asyncrun.extra', opt = true}
    },
  }

  use {
    'mbbill/undotree',
    opt = true,
    cmd = {'UndotreeToggle'},
    config = function() vim.cmd('let g:undotree_WindowLayout = 3 | let g:undotree_SetFocusWhenToggle = 1') end,
  }

  use {
    'junegunn/vim-peekaboo'
  }

  use {
    'tpope/vim-surround'
  }

  use {
    'liuchengxu/vista.vim',
    config = function() vim.cmd('runtime plug-config/vista.vim') end,
    opt = true,
    cmd = {'Vista'}
  }

  use {
    'machakann/vim-highlightedyank',
    config = function() vim.cmd('let g:highlightedyank_highlight_duration=300') end,
  }

  use {
    'lambdalisue/suda.vim',
    opt = true,
    cmd = {'SudaRead', 'SudaWrite'}
  }

  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install']() end,
    config = function ()
      vim.g.mkdp_auto_close = 0
    end,
    ft = {'markdown'}
  }

  use {
    'masukomi/vim-markdown-folding',
    ft = {'markdown'},
    config = function()
      vim.g.markdown_fold_style = 'nested'
    end
  }

  use {
    'neoclide/coc.nvim',
    branch = 'release',
    opt = true,
    config = function() vim.cmd('runtime plug-config/coc.vim') end
  }

  -- use {
  --   'liuchengxu/vim-which-key',
  --   config = function() vim.cmd('runtime whichkey.vim') end
  -- }

  use {
    "folke/which-key.nvim",
    config = function()
      require("config/whichkey")
    end
  }

  use {
    'gelguy/wilder.nvim',
    run = ':UpdateRemotePlugins',
    config = function()
      vim.cmd('runtime plug-config/wilder.vim')
    end
  }

  -- use {
  --   'nvim-telescope/telescope.nvim',
  --   config = function()
  --     local actions = require('telescope.actions')
  --     local telescope = require('telescope')
  --     telescope.setup {
  --       defaults = {
  --         path_display = { truncate = 2 },
  --         mappings = {
  --           i = {
  --             ["<esc>"] = actions.close
  --           },
  --         },
  --       }
  --     }
  --     telescope.load_extension('fzf')
  --   end,
  --   requires = {
  --     {'nvim-lua/plenary.nvim'},
  --     {'nvim-telescope/telescope-fzf-native.nvim', run='make'}
  --   }
  -- }

end)
