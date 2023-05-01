-- Options
vim.opt.path:append { '**' }
vim.opt.mouse = 'a'
vim.opt.laststatus = 1
vim.opt.autoread = false
vim.opt.autowrite = true
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.tags = { '/usr/include/tags' , 'tags'}
vim.opt.spelllang = 'en'
vim.g.mapleader = ','

-- Rgrep
vim.opt.grepprg='grep -rn --exclude-dir=.git --exclude-dir=build --exclude=tags --exclude=\\*.{swp,o}'
vim.cmd([[command! -nargs=+ Rgrep execute 'silent grep! <args>' | botright copen | setlocal nobuflisted | redraw!]])
vim.keymap.set('n', 'gr', ':Rgrep <cword><CR>', { noremap=true })

-- Keymaps
vim.keymap.set('n', 't', '<c-t>', { noremap=true })
vim.keymap.set('n', 'Y', '+y', { noremap=true })
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '<tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-tab>', ':bprevious<CR>')
vim.keymap.set('n', '<leader>s', ':set spell!<CR>')
vim.keymap.set('n', '<leader>n', ':setlocal number!<CR>')
vim.keymap.set('n', '<leader>p', ':set paste!<CR>')
vim.keymap.set('n', '<leader>b', ':set scb!<CR>')

-- Plugins
require('lua/plugins')
require('lua/plugin-config')
