local M = {
  "hrsh7th/nvim-cmp",
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
  },
}

function M.config()
  local cmp = require('cmp')
  local compare = require('cmp.config.compare')
  cmp.setup {
    snippet = {
      expand = function(args) require('luasnip').lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-h>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),

      -- Accept currently selected item. Set `select` to `false` to only
      -- confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    }),
  }

  cmp.setup.filetype('html', {
    sorting = {
      comparators = {
        function(e1, e2)
          if require('cmp.types').lsp.CompletionItemKind[e1:get_kind()] == 'Snippet' then
            return false
          end

          if require('cmp.types').lsp.CompletionItemKind[e2:get_kind()] == 'Snippet' then
            return true
          end
        end,
        compare.offset,
        compare.exact,
        -- compare.scopes,
        compare.score,
        compare.recently_used,
        compare.locality,
        compare.kind,
        -- compare.sort_text,
        compare.length,
        compare.order,
      }
    }
  })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources {
      { name = 'buffer' }
    },
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline',
          -- keyword_pattern =[=[[^[:blank:]\!]*]=]
        }
    }),
  })

  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end

return M
