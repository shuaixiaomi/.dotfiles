local nvim_colorizer_ft = { 'vim', 'lua', 'css', 'conf', 'tmux', 'bash' }

local has_mac = vim.fn.has('mac') == 1
local has_wsl = vim.fn.has('wsl') == 1

local opts = {
  concurrency = (function()
    return 30
  end)(),
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "editorconfig",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "man",
        "matchit",
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "rplugin",
        "rrhelper",
        "spellfile",
        "spellfile_plugin",
        "tar",
        "tarPlugin",
        "tohtml",
        "tutor",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },
}

require("lazy").setup({
  {
    'sainnhe/edge',
    init = function()
      vim.g.edge_better_performance = 1
      vim.g.edge_enable_italic = 0
      vim.g.edge_disable_italic_comment = 1
      -- StatusLine 左边
      -- vim.api.nvim_set_hl(0, "StatusLine", { fg = '#373943' })
      -- vim.api.nvim_set_hl(0, "StatusLineNC", { fg = '#373943' })
    end,
    config = function()
      vim.cmd.colorscheme('edge')
      vim.g.edge_loaded_file_types = { 'NvimTree' }
      vim.api.nvim_set_hl(0, "StatusLine", { fg = '#c5cdd9', bg = '#23262b' })

      vim.cmd [[
      hi! Folded guifg=#282c34 guibg=#5c6370
      hi MatchParen guifg=#ffef28
      ]]
    end,
  },
  
  -- treesiter
  {
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        require('lu5je0.ext.treesiter')
      end,
      event = 'VeryLazy'
    },
    {
      "ThePrimeagen/refactoring.nvim",
      config = function()
        require('lu5je0.ext.refactoring').setup()
      end,
      keys = { { mode = { 'n', 'x' }, '<leader>c' } },
    },
    {
      'm-demare/hlargs.nvim',
      config = function()
        require('hlargs').setup {
          -- flash.nvim 5000
          hl_priority = 4999
        }
      end,
      dependencies = {
        'nvim-treesitter/nvim-treesitter'
      },
      event = 'VeryLazy'
    },
    {
      'phelipetls/jsonpath.nvim',
      ft = { 'json', 'jsonc' }
    },
    -- {
    --   'stevearc/aerial.nvim',
    --   config = function()
    --     require('lu5je0.ext.aerial')
    --   end,
    --   cmd = { 'AerialToggle' }
    -- },
  },
  
  {
    'tpope/vim-repeat',
    event = 'VeryLazy',
    config = function()
      require('lu5je0.ext.repeat').setup()
    end
  },
  {
    'aklt/plantuml-syntax',
    ft = 'plantuml',
    keys = '<leader>fn',
    dependencies = {
      {
        'weirongxu/plantuml-previewer.vim',
        'tyru/open-browser.vim'
      }
    }
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('lu5je0.ext.gitsigns').setup()
    end,
    event = 'VeryLazy'
  },
  {
    'ojroques/vim-oscyank',
    init = function()
      vim.g.oscyank_silent = 1
      vim.g.oscyank_trim = 0
    end,
    config = function()
      if has_wsl or has_mac then
        return
      end
      vim.api.nvim_create_autocmd('TextYankPost', {
        pattern = '*',
        callback = function()
          vim.cmd [[ OSCYankRegister " ]]
        end,
      })
    end,
    event = 'VeryLazy'
  },
  
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gvdiffsplit', 'Gstatus', 'Gclog', 'Gread' },
    config = function()
      require('lu5je0.ext.fugitive').setup()
    end
  },
  {
    'rbong/vim-flog',
    cmd = { 'Flogsplit', 'Floggit', 'Flog' },
    keys = { { mode = 'n', '<leader>gL' }, { mode = 'x', '<leader>gl' } },
    dependencies = {
      'tpope/vim-fugitive',
    },
    config = function()
      vim.cmd [[
      augroup flog
      autocmd FileType floggraph nmap <buffer> <leader>q ZZ
      augroup END
      ]]
    end
  },
  {
    'mattn/vim-gist',
    config = function()
      vim.cmd("let github_user = 'lu5je0@gmail.com'")
      vim.cmd('let g:gist_show_privates = 1')
      vim.cmd('let g:gist_post_private = 1')
    end,
    dependencies = {
      'mattn/webapi-vim'
    },
    cmd = 'Gist'
  },
  
  {
    'kyazdani42/nvim-web-devicons',
    -- config = function()
    --   require('nvim-web-devicons').setup {
    --     override = {
    --       xml = {
    --         icon = '󰈛',
    --         color = '#e37933',
    --         name = 'Xml',
    --       },
    --     },
    --     default = true,
    --   }
    -- end,
    lazy = true
  },
  
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    config = function()
      require('lu5je0.ext.telescope').setup()
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = { ',' }
  },
  
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('lu5je0.ext.projects').setup()
    end,
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    keys = { '<leader>fp' },
  },
  
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lu5je0.ext.lualine')
    end,
    event = 'VeryLazy'
  },
  {
    'lu5je0/bufferline.nvim',
    config = function()
      vim.g.bufferline_separator = true
      require('lu5je0.ext.bufferline')
    end,
    dependencies = { 'kyazdani42/nvim-web-devicons' },
  },
  {
    'kyazdani42/nvim-tree.lua',
    -- just lock，in case of break changes
    commit = 'f39f7b6fcd3865ac2146de4cb4045286308f2935',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require('lu5je0.ext.nvimtree').setup()
    end,
    cmd = { 'NvimTreeOpen' },
    keys = { '<leader>e', '<leader>fe' },
  },
  {
    'theniceboy/vim-calc',
    config = function ()
      vim.keymap.set('n', '<leader>a', vim.fn.Calc)
    end,
    keys = { '<leader>a' }
  },
  -- {
  --   'rootkiter/vim-hexedit',
  --   ft = 'bin',
  -- },
  {
    'sgur/vim-textobj-parameter',
    dependencies = { 'kana/vim-textobj-user' },
    init = function()
      vim.g.vim_textobj_parameter_mapping = 'a'
    end,
    keys = { { mode = 'x', 'ia' }, { mode = 'o', 'ia' }, { mode = 'x', 'aa' }, { mode = 'o', 'aa' },
      { mode = 'n', 'cxia' }, { mode = 'n', 'cxaa' } }
  },
  {
    "gbprod/substitute.nvim",
    config = function()
      require('lu5je0.ext.substitute')
    end,
    keys = { { mode = 'n', 'cx' }, { mode = 'x', 'gr' }, { mode = 'n', 'gr' } }
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup {
        move_cursor = false
      }
    end,
    keys = { { mode = 'n', 'cs' }, { mode = 'n', 'cS' }, { mode = 'n', 'ys' }, { mode = 'n', 'ds' }, { mode = 'x', 'S' } }
  },
  {
    'othree/eregex.vim',
    init = function()
      vim.g.eregex_default_enable = 0
    end,
    cmd = 'S',
    keys = { '<leader>/' },
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('lu5je0.ext.comment').setup()
    end,
    keys = { { mode = 'x', 'gc' }, { mode = 'n', 'gc' }, { mode = 'n', 'gcc' }, { mode = 'n', 'gC' } }
  },
  {
    'akinsho/toggleterm.nvim',
    branch = 'main',
    config = function()
      require('lu5je0.ext.terminal').setup()
    end,
    keys = { { mode = { 'i', 'n' }, '<m-i>' }, { mode = { 'i', 'n' }, '<d-i>' } }
  },
  {
    'mg979/vim-visual-multi',
    init = function()
      vim.g.VM_maps = {
        ['Select Cursor Down'] = '<m-n>',
        ['Remove Region'] = '<c-p>',
        ['Skip Region'] = '<c-x>',
        ['VM-Switch-Mode'] = 'v',
      }
    end,
    config = function()
      require('lu5je0.ext.vim-visual-multi').setup()
    end,
    keys = { { mode = { 'n', 'x' }, '<c-n>' }, { mode = { 'n', 'x' }, '<m-n>' } },
  },

  {
    'lu5je0/vim-translator',
    config = function()
      require('lu5je0.ext.vim-translator')
    end,
    keys = { { mode = 'x', '<leader>sa' }, { mode = 'x', '<leader>ss' }, { mode = 'n', '<leader>ss' },
      { mode = 'n', '<leader>sa' } }
  },

  {
    'dstein64/vim-startuptime',
    config = function()
      vim.cmd("let $NEOVIM_MEASURE_STARTUP_TIME = 'TRUE'")
    end,
    cmd = { 'StartupTime' },
  },

  {
    'mbbill/undotree',
    keys = { '<leader>u' },
    config = function()
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SetFocusWhenToggle = 1

      local function undotree_toggle()
        if vim.bo.filetype ~= 'undotree' and vim.bo.filetype ~= 'diff' then
          local winnr = vim.fn.bufwinnr(0)
          vim.cmd('UndotreeToggle')
          vim.cmd(winnr .. ' wincmd w')
          vim.cmd('UndotreeFocus')
        else
          vim.cmd('UndotreeToggle')
        end
      end

      vim.keymap.set('n', '<leader>u', undotree_toggle, {})
    end,
  },

  -- {
  --   'junegunn/vim-peekaboo'
  -- },

  {
    'folke/which-key.nvim',
    config = function()
      require('lu5je0.ext.whichkey').setup()
    end,
    keys = { ',' },
  },

  {
    'Pocco81/HighStr.nvim',
    config = function()
      require('lu5je0.ext.highstr')
    end,
    keys = {
      { mode = { 'v' }, '<leader>my' },
      { mode = { 'v' }, '<leader>mg' },
      { mode = { 'v' }, '<leader>mr' },
      { mode = { 'v' }, '<leader>mb' },
      { mode = { 'v', 'n' }, '<leader>mc' }
    }
  },

  -- {
  --   'dstein64/nvim-scrollview',
  --   config = function()
  --     require('lu5je0.ext.scrollview').setup()
  --   end,
  --   event = { 'VeryLazy' }
  -- },
  
  {
    'lewis6991/satellite.nvim',
    config = function()
      require('lu5je0.ext.satellite').setup()
    end,
    event = { 'WinScrolled' }
  },

  -- nvim-cmp
  {
    {
      'hrsh7th/nvim-cmp',
      config = function()
        require('lu5je0.ext.cmp')
      end,
      dependencies = {
        -- 'hrsh7th/cmp-cmdline',
        'windwp/nvim-autopairs',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        {
          'L3MON4D3/LuaSnip',
          config = function()
            require('lu5je0.ext.luasnip').setup()
          end
        },
        -- {
        --   'hrsh7th/vim-vsnip',
        --   config = function()
        --     require('lu5je0.ext.vsnip').setup()
        --   end,
        -- },
        -- 'hrsh7th/cmp-vsnip',
      },
      event = 'InsertEnter',
    },
    {
      'hrsh7th/cmp-nvim-lsp',
      event = 'LspAttach'
    },
  },

  -- {
  --   "elihunter173/dirbuf.nvim",
  --   config = function()
  --     require('lu5je0.ext.dirbuf')
  --   end,
  --   cmd = 'Dirbuf'
  -- },
  
  {
    'stevearc/oil.nvim',
    config = function()
      require("oil").setup {
        buf_options = {
          buflisted = true
        },
        columns = {
          -- "icon",
          -- "size",
          -- "mtime",
        },
        use_default_keymaps = false,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["gs"] = "actions.change_sort",
          ["g."] = "actions.toggle_hidden",
          ["-"] = "actions.parent",
        }
      }
    end,
    cmd = 'Oil'
  },
  
  {
    'MunifTanjim/nui.nvim',
    commit = '7427f979cc0dc991d8d177028e738463f17bcfcb',
    lazy = true
  },
  
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    config = function()
      require('lu5je0.ext.nvim-ufo')
    end,
    event = 'VeryLazy'
    -- cmd = 'FoldTextToggle',
    -- keys = { 'zf', 'zo', 'za', 'zc', 'zM', 'zR' }
  },
  {
    'anuvyklack/pretty-fold.nvim',
    config = function()
      require('pretty-fold').setup({
        fill_char = ' ',
      })
    end,
    lazy = true
  },
  
  {
    'nat-418/boole.nvim',
    config = function()
      require('boole').setup {
        mappings = {
          increment = '<c-a>',
          decrement = '<c-x>'
        },
        -- User defined loops
        additions = {
          -- {'Foo', 'Bar'},
        },
        allow_caps_additions = {
          -- enable → disable
          -- Enable → Disable
          -- ENABLE → DISABLE
          { 'enable', 'disable' },
        }
      }
    end,
    keys = { '<c-a>', '<c-x>' }
  },
  {
    "smjonas/live-command.nvim",
    config = function()
      require("live-command").setup {
        commands = {
          Norm = { cmd = "norm" },
        },
      }
    end,
    event = { 'CmdlineEnter' }
  },
  {
    'AckslD/messages.nvim',
    config = function()
      require("messages").setup {
        post_open_float = function(_)
          vim.cmd [[
          au! BufLeave * ++once lua vim.cmd(":q")
          set number
          ]]
          vim.fn.cursor { 99999, 0 }
        end
      }
    end,
    cmd = 'Messages',
  },
  
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('lu5je0.ext.indent-blankline')
    end,
    event = 'VeryLazy'
  },

  -- lsp
  {
    {
      'williamboman/mason.nvim',
      config = function()
        require("mason").setup()
      end,
      event = 'VeryLazy'
    },
    {
      'williamboman/mason-lspconfig.nvim',
      config = function()
        require('mason-lspconfig').setup {
          ensure_installed = {}
        }
      end,
      event = 'VeryLazy',
      dependencies = {
        'williamboman/mason.nvim',
        {
          'neovim/nvim-lspconfig',
          dependencies = {
            {
              'folke/neodev.nvim',
              config = function()
                require("neodev").setup {
                  library = {
                    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
                    -- these settings will be used for your Neovim config directory
                    runtime = true, -- runtime path
                    types = true,   -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
                    plugins = false,
                    -- plugins = { 'nui.nvim', 'nvim-tree.lua', "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
                  },
                }
              end
            },
          },
          config = function()
            require('lu5je0.ext.lspconfig.lsp').setup()
          end,
        },
        -- {
        --   "lu5je0/lspsaga.nvim",
        --   branch = "main",
        --   config = function()
        --     require('lu5je0.ext.lspconfig.lspsaga')
        --   end,
        --   dependencies = {
        --     'neovim/nvim-lspconfig'
        --   }
        -- },
      }
    },
    {
      'SmiteshP/nvim-navic',
      config = function()
        require('nvim-navic').setup {
          depth_limit = 4,
          depth_limit_indicator = "..",
        }
      end,
      event = { 'LspAttach' }
    },
    {
      'simrat39/symbols-outline.nvim',
      config = function()
        require('lu5je0.ext.symbols-outline').setup()
      end,
      cmd = { 'SymbolsOutline' },
      keys = { { mode = { 'n' }, '<leader>i' }, { mode = { 'n' }, '<leader>I' } }
    },
    {
      "dnlhc/glance.nvim",
      config = function()
        require('lu5je0.ext.glance').setup()
      end,
      event = { 'LspAttach' }
    },
    {
      'RRethy/vim-illuminate',
      config = function()
        require('lu5je0.ext.lspconfig.illuminate')
      end,
      dependencies = {
        'neovim/nvim-lspconfig'
      },
      event = { 'CursorHold', 'LspAttach' }
    },
    {
      'nvimtools/none-ls.nvim',
      config = function()
        require('lu5je0.ext.null-ls.null-ls')
      end,
      dependencies = {
        'neovim/nvim-lspconfig'
      },
      event = 'VeryLazy'
      -- cmd = 'NullLsEnable',
    },
  },

  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end,
    cmd = 'InsertEnter'
  },
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup {
        filetypes = nvim_colorizer_ft,
        user_default_options = {
          names = false,
          mode = "virtualtext"
        }
      }
    end,
    ft = nvim_colorizer_ft,
  },
  {
    'lambdalisue/suda.vim',
    cmd = { 'SudaRead', 'SudaWrite' },
  },
  {
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    config = function()
      vim.g.mkdp_auto_close = 0
    end,
    ft = { 'markdown' },
  },
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { 'norg' },
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/notes",
            },
          },
        },
      },
    }
    end,
  },
  
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      require('lu5je0.ext.dap').setup()
    end,
    keys = { '<F10>', '<S-F10>' },
  },
  {
    'jbyuki/one-small-step-for-vimkind',
    config = function()
      vim.api.nvim_create_user_command('LuaDebug', function()
        require("osv").launch({ port = 8086 })
      end, { force = true })
    end,
    cmd = 'LuaDebug'
  },
  
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      local builtin = require("statuscol.builtin")
      vim.o.foldcolumn = '0'
      require("statuscol").setup({
        -- configuration goes here, for example:
        ft_ignore = { 'NvimTree', 'undotree', 'diff', 'Outline', 'dapui_scopes', 'dapui_breakpoints', 'dapui_repl' },
        bt_ignore = { 'terminal' },
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          {
            sign = { name = { "DapBreakpoint" }, maxwidth = 2, colwidth = 2, auto = true },
            click = "v:lua.ScSa"
          },
          {
            sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false, wrap = true },
            click = "v:lua.ScSa",
            condition = { function(args)
              return vim.wo[args.win].number
              -- return vim.wo[args.win].signcolumn ~= 'no'
            end }
          },
          {
            text = { function(args)
              if not vim.wo[args.win].number then
                return builtin.lnumfunc(args)
              end

              local num = ''
              if args.lnum < 10 then
                num = ' ' .. builtin.lnumfunc(args)
              else
                num = builtin.lnumfunc(args)
              end
              return num .. ' '
            end },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          }
        },
      })
    end,
    event = 'VeryLazy'
  },
  
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    config = function()
      require("lu5je0.ext.edgy").setup()
    end
  },
  
  -- {
  --   'akinsho/git-conflict.nvim',
  --   version = "*",
  --   config = true,
  --   event = 'VeryLazy'
  -- },
  
  {
    'nvim-pack/nvim-spectre',
    config = function()
      require('lu5je0.ext.spectre').setup()
    end,
    cmd = 'Spectre',
    -- event = 'VeryLazy'
    keys = { { mode = { 'x' }, '<leader>xr' }, { mode = 'n', '<leader>xf' } },
  },
  
  {
    'stevearc/profile.nvim',
    -- 最新的版本直接报错了，先lock到这个版本
    -- commit = 'd0d74adabb90830bd96e5cdfc8064829ed88b1bb',
    config = function()
      local function toggle_profile()
        local prof = require("profile")
        if prof.is_recording() then
          prof.stop()
          vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
            if filename then
              prof.export(filename)
              vim.notify(string.format("Wrote %s", filename))
            end
          end)
        else
          print('profile started')
          prof.start("*")
        end
      end
      vim.keymap.set("", "<leader>pp", toggle_profile)
    end,
    keys = { { mode = { 'n' }, '<leader>pp' } }
  },
  
  {
    "folke/flash.nvim",
    keys = { { mode = { 'n', 'x' }, 's' }, { mode = { 'n' }, 'S' }, { mode = { 'o' }, 'r' } },
    config = function()
      require('flash').setup {
        search = { multi_window = false },
        modes = { char = { enabled = false }, search = { enabled = false } },
        prompt = { enabled = false },
        highlight = { priority = 9999 }
      }
      vim.keymap.set({ 'n', 'x' }, 's', require("flash").jump)
      vim.keymap.set('n', 'S', require("flash").treesitter)
      vim.keymap.set('o', 'r', require("flash").remote)
      vim.api.nvim_create_user_command('FlashSearchToggle', function() require("flash").toggle() end, {})
    end
  },
  
  -- {
  --   '3rd/image.nvim',
  --   config = function()
  --     package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
  --     package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
  --     require('image').setup({
  --      -- backend = 'ueberzug',
  --      backend = "kitty",
  --      integrations = {
  --        markdown = {
  --          enabled = true,
  --          clear_in_insert_mode = false,
  --          download_remote_images = true,
  --          only_render_image_at_cursor = false,
  --          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
  --        },
  --        neorg = {
  --          enabled = true,
  --          clear_in_insert_mode = false,
  --          download_remote_images = true,
  --          only_render_image_at_cursor = false,
  --          filetypes = { "norg" },
  --        },
  --      },
  --      max_width = nil,
  --      max_height = nil,
  --      max_width_window_percentage = nil,
  --      max_height_window_percentage = 50,
  --      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
  --      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  --      kitty_method = "normal",
  --     })
  --   end
  -- }
  
  -- {
  --   'tzachar/highlight-undo.nvim',
  --   config = function()
  --     require('highlight-undo').setup({
  --       hlgroup = 'Visual',
  --       duration = 300,
  --       keymaps = {
  --         {'n', 'u', 'undo', {}},
  --         {'n', '<C-r>', 'redo', {}},
  --       }
  --     })
  --   end,
  --   event = 'VeryLazy'
  -- },
  
  {
    "FabijanZulj/blame.nvim",
    cmd = "ToggleBlame",
    config = function()
      require('blame').setup {
        width = 40,
      }
    end,
    keys = {
      { "<leader>gb", ":ToggleBlame window<cr>", desc = "ToggleGitBlame" },
    },
  },
  
  {
    "LunarVim/bigfile.nvim",
    config = function()
      require('lu5je0.misc.big-file').setup()
    end
  }
  
}, opts)
