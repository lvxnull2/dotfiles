local options = {
  number = true,
  relativenumber = true,
  ignorecase = true,
  smartcase = true,
  colorcolumn = '79',
  expandtab = true,
  tabstop = 8,
  softtabstop = -1,
  shiftwidth = 4,
  scrolloff = 5,
  -- termguicolors = true,
  title = true,
  mouse = '',
  guifont = 'Hack Nerd Font Mono:h12',
}
local util = require('lvxnull.util')

util.merge(vim.o, options)

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.shortmess:append('I')

vim.cmd.filetype('indent on')

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('lvxnull.plugins', {
  install = {
    colorscheme = { 'carbonfox', 'habamax' },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'tutor',
        'tohtml',
        'netrwPlugin',
        'man',
        'zipPlugin'
      }
    }
  }
})

vim.api.nvim_create_autocmd('BufRead', {
  pattern = "PKGBUILD",
  callback = function (ev)
    vim.o.shellredir = '>'
  end
})

util.map('', 'H', '^')
util.map('', 'L', '$')

util.map({'', 'i'}, '<PageUp>', '')
util.map({'', 'i'}, '<PageDown>', '')
util.map({'n', 'i'}, '<F1>', '')

util.map('n', '<Leader>%', '<CMD>vsplit<CR>', 'Split vertically')
util.map('n', '<Leader>"', '<CMD>split<CR>', 'Split horizontally')
util.map('n', ']q', '<CMD>cnext<CR>', 'Next quickfix location')
util.map('n', '[q', '<CMD>cprevious<CR>', 'Previous quickfix location')
util.map('n', '<Leader>ol', '<CMD>Lazy<CR>', 'Open lazy.nvim')

local url_regex = vim.regex('\\v%(file|https?)://[^()\'"<>^`{|}\\[\\]]+')
util.map({'n', 'v'}, 'gx', function ()
  --- @type string
  local mode = vim.fn.mode()
  local url
  if mode == 'v' then
    url = util.visual_selection()
  else
    url = vim.fn.expand('<cWORD>')
  end

  local i, j = url_regex:match_str(url)
  if not i then
    vim.notify('Invalid URL', vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart({'xdg-open', url:sub(i + 1, j)}, {
    stdin = "null",
    detach = true,
  })
end, 'Open in browser')
