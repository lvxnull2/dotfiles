local P = {
  {
    'folke/lazy.nvim',
    version = '*',
  },

  -- Language support
  {
    'rust-lang/rust.vim',
    ft = 'rust',
  },

  inline_edit = {
    'AndrewRadev/inline_edit.vim',
    cmd = 'InlineEdit',
  },

  -- UI
  lualine = {
    'nvim-lualine/lualine.nvim',
    config = true,
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    config = true,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      scope = {
        show_start = false,
        show_end = false,
      },
    },
  },
  colorizer = {
    'NvChad/nvim-colorizer.lua',
    ft = { 'css', 'html' },
    opts = {
      filetypes = { 'css', 'html', },
      user_default_options = {
        css = true,
      },
    },
  },
  treesitter = {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  nightfox = {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
  },

  -- Editor features
  which_key = {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    name = 'which-key',
    version = '1.4.*',
  },
  trouble = {
    'folke/trouble.nvim',
    config = true,
    cmd = { 'Trouble', 'TroubleToggle' }
  },
  hop = {
    'phaazon/hop.nvim',
    event = 'BufEnter',
    keys = {
      { 'gh', '<CMD>HopChar2<CR>', mode = '' },
      { '<CR>', '<CMD>HopChar2<CR>', mode = '' },
      { '<Leader>gl', '<CMD>HopLine<CR>', mode = '', desc = 'Line' },
    },
    config = true,
  },
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = true,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      map_cr = false,
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufRead', 'BufWrite' },
    keys = {
      {'<Leader>vs', '<CMD>Gitsigns stage_hunk<CR>', desc = 'Stage hunk', mode = {'n', 'v'}},
      {'<Leader>vS', '<CMD>Gitsigns stage_buffer<CR>', desc = 'Stage buffer'},
      {'<Leader>vx', '<CMD>Gitsigns reset_hunk<CR>', desc = 'Discard hunk', mode = {'n', 'v'}},
      {'<Leader>vX', '<CMD>Gitsigns reset_buffer<CR>', desc = 'Discard buffer'},
      {'<Leader>vv', '<CMD>Gitsigns setqflist<CR>', desc = 'Show hunks'},
    },
    opts = {
      signs = {
        add = { text = '│' },
        change = { text = '│' },
      },
    },
    tag = 'release'
  },
  {
    'tpope/vim-fugitive',
    cmd = 'Git',
    keys = {
      { '<Leader>og', '<CMD>Git<CR>', desc = 'Fugitive' },
      { '<Leader>vp', '<CMD>Git push<CR>', desc = 'Push' },
    }
  },
  mini = {
    'echasnovski/mini.nvim',
    version = false,
    keys = {
      { 'gc', mode = '' },
      'gcc'
    },
  },
  lint = {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  formatter = {
    'mhartington/formatter.nvim',
  },
  luasnip = {
    'L3MON4D3/LuaSnip',
    name = false,
    version = '2.*',
    event = 'BufReadPre *.snippets',
    keys = {
      {'<Tab>', function()
        if require('luasnip').expand_or_jumpable() then
          return '<Plug>luasnip-expand-or-jump'
        end
        return '<Tab>'
      end, mode = 'i', expr = true, remap = true, silent = true}
    },
    opts = {
      enable_autosnippets = true,
    },
  },
  telescope = {
    'nvim-telescope/telescope.nvim', version = '0.*',
    cmd = 'Telescope',
    keys = {
      {'<Leader>gf', '<CMD>Telescope find_files file_only=true<CR>', desc = 'File'},
      {'<Leader>gF', '<CMD>Telescope find_files<CR>', desc = 'File/directory'},
      {'<Leader>of', '<CMD>Telescope file_browser<CR>', desc = 'File browser'},
      {'<Leader>gb', '<CMD>Telescope buffers<CR>', desc  = 'Buffer'},
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-file-browser.nvim',
        lazy = true,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
      },
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = require('lvxnull.util').make,
  },
}

function P.which_key.config()
  local wk = require('which-key')
  wk.setup()

  wk.register({
    o = { name = "open" },
    g = { name = "go" },
    v = { name = 'version control' },
    l = { name = 'lsp' },
    w = { name = 'workspace' },
  }, {
    prefix = "<leader>"
  })
end

function P.nightfox.config()
 vim.cmd.colorscheme('carbonfox')
end

function P.treesitter.config()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'lua',
      'vimdoc',
      'bash',
      'python',
      'json',
      'toml',
      'yaml',
    },
    highlight = {
      enable = true,
      disable = function(lang, bufnr)
        return require('lvxnull.util').is_huge(bufnr)
      end,
      additional_vim_regex_highlighting = true,
    },
    indent = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['if'] = '@function.inner',
          ['af'] = '@function.outer',
          ['ip'] = '@block.inner',
          ['ap'] = '@block.outer',
        },
      },
    },
  }
  vim.treesitter.language.register('bash', 'zsh')
end

function P.inline_edit.init()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'html', 'htmldjango' },
    callback = function(ev)
      require('lvxnull.util').map('n', '<localleader>e', ':InlineEdit<CR>', 'Edit inline javascript', { buffer = ev.buf })
    end,
  })
end

function P.inline_edit.config()
  vim.g.inline_edit_proxy_type = 'tempfile'
  vim.g.inline_edit_modify_statusline = 0
end

function P.mini.config()
  require('mini.comment').setup()
end

function P.lint.config()
  local function if_exists(...)
    local output = {}
    for _, v in ipairs({...}) do
      if vim.fn.executable(v) ~= 0 then
        table.insert(output, v)
      end
    end

    return output
  end

  require('lint').linters_by_ft = {
    sh = if_exists('shellcheck'),
  }

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sh' },
    callback = function (args)
      vim.api.nvim_create_autocmd({'InsertLeave', 'TextChanged'}, {
        buffer = args.buf,
        callback = function () require('lint').try_lint() end,
      })
    end
  })

  vim.api.nvim_create_autocmd({'BufRead', 'BufWritePost'}, {
    callback = function () require('lint').try_lint() end,
  })
end

function P.formatter.config()
  require('formatter').setup {
    filetype = {
      lua = {
        require("formatter.filetypes.lua").stylua,
      },
      python = {
        require('formatter.filetypes.python').isort,
        require('formatter.filetypes.python').black,
      }
    }
  }
end

function P.luasnip.config(p, opts)
  require("luasnip").setup(opts)
  require("luasnip.loaders.from_snipmate").lazy_load()
end

function P.telescope.config()
  local fb_actions = require('telescope').extensions.file_browser.actions
  require('telescope').setup {
    pickers = {
      find_files = {
        hidden = true,
      },
    },
    extensions = {
      file_browser = {
        hijack_netrw = true,
        hidden = true,
        hide_parent_dir = true,
        mappings = {
          ['n'] = {
            ['u'] = fb_actions.goto_parent_dir,
            ['g'] = false,
          },
          ['i'] = {
            ["<C-c>"] = fb_actions.create_from_prompt,
          },
        },
      },
    },
  }

  require('telescope').load_extension('file_browser')
  require('telescope').load_extension('fzf')
end

return require('lvxnull.util').flatten_plugins(P)
