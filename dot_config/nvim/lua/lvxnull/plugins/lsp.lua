local P = {
  lspconfig = {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      { '[d', vim.diagnostic.goto_prev, desc = 'Previous diagnostic' },
      { ']d', vim.diagnostic.goto_next, desc = 'Next diagnostic' },
    }
  },
}

--- @type table<string, table>
local LSP = {
  gopls = {},
  clangd = {},
  jsonls = {},
  rust_analyzer = {},
  pyright = {},
  emmet_ls = {
    filetypes = { 'html', 'htmldjango' },
  },
  html = {},
  cssls = {},
  ts_ls = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
}

-- Use an LspAttach callback to only map the following keys
-- after the language server attaches to the current buffer
local function setup_buffer(ev)
  -- Enable completion triggered by <c-x><c-o>
  -- vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = {buffer = ev.buf}
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  local map = require('lvxnull.util').map

  map('n', 'K', vim.lsp.buf.hover, bufopts)
  map('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

  -- Go to
  map('n', 'gd', ':Telescope lsp_definitions<CR>', 'Definition', bufopts)
  map('n', 'gD', vim.lsp.buf.declaration, 'Declaration', bufopts)
  map('n', 'gi', ':Telescope lsp_implementations<CR>', 'Implementation', bufopts)
  map('n', 'gr', ':Telescope lsp_references<CR>', 'References', bufopts)
  map('n', 'gt', ':Telescope lsp_type_definitions<CR>', 'Type definition', bufopts)

  -- Workspace
  map('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, 'Add', bufopts)
  map('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove', bufopts)
  map('n', '<Leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, 'List', bufopts)

  -- LSP
  map('n', '<Leader>la', vim.lsp.buf.code_action, 'Code action', bufopts)
  map('n', '<Leader>lf', function() vim.lsp.buf.format { async = true } end, 'Format', bufopts)
  map('n', '<Leader>lr', vim.lsp.buf.rename, 'Rename', bufopts)

  if client.name == 'clangd' then
    map('n', '<Localleader>s', '<CMD>ClangdSwitchSourceHeader<CR>')
  end
end

local capabilities

local function default_options()
  if not capabilities then
    capabilities = require('cmp_nvim_lsp').default_capabilities()
  end

  return {
    capabilities = capabilities,
  }
end

function P.lspconfig.config()
  for k, v in pairs(LSP) do
    local opts = vim.tbl_extend('force', default_options(), v)

    require('lspconfig')[k].setup(opts)
  end
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = setup_buffer,
  })
end

return require('lvxnull.util').flatten_plugins(P)
