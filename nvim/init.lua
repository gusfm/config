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
vim.opt.tags = { '/usr/include/tags' , 'tags' }
vim.opt.spelllang = 'en'
vim.opt.clipboard = unnamed
vim.opt.number = true

-- Return to the last position in file
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = {"*"},
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.api.nvim_exec("normal! g'\"",false)
        end
    end
})

-- Rgrep
vim.opt.grepprg='grep -rn --exclude-dir=.git --exclude-dir=build --exclude=tags --exclude=\\*.{swp,o}'
vim.cmd([[command! -nargs=+ Rgrep execute 'silent grep! <args>' | botright copen | setlocal nobuflisted | redraw!]])
vim.keymap.set('n', 'gr', ':Rgrep <cword><CR>', { noremap=true })

-- Keymaps
vim.keymap.set('n', 't', '<c-t>', { noremap=true })
vim.keymap.set('n', 'Y', '+y', { noremap=true })
vim.keymap.set({'n','v'}, 'j', 'gj')
vim.keymap.set({'n','v'}, 'k', 'gk')
vim.keymap.set('n', '<tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-tab>', ':bprevious<CR>')
vim.keymap.set('n', '<leader>s', ':set spell!<CR>')
vim.keymap.set('n', '<leader>n', ':set number!<CR>')
vim.keymap.set('n', '<leader>p', ':set paste!<CR>')
vim.keymap.set('n', '<leader>b', ':set scb!<CR>')
-- Primary selection with mouse
vim.keymap.set('v', '<LeftRelease>', '"*ygv', { noremap = true, silent = true })
vim.keymap.set('v', '<2-LeftRelease>', '"*ygv', { noremap = true, silent = true })

-- Clang-format
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.c,*.cc,*.h,*.hh',
  command = "%py3f /usr/share/vim/addons/syntax/clang-format.py"
})
vim.keymap.set('n', '<c-k>', ':py3f /usr/share/vim/addons/syntax/clang-format.py<CR>', { noremap=true })

-- Plugins
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
   -- Git
    {'tpope/vim-fugitive'},
    -- Syntax highlight
    {"nvim-treesitter/nvim-treesitter", branch = 'main', lazy = false, build = ":TSUpdate"},
    -- Colorschemes
    {"ellisonleao/gruvbox.nvim"},
    {"tpope/vim-vividchalk"}
  },
})

--vim.cmd.colorscheme('gruvbox')
vim.cmd.colorscheme('vividchalk')
