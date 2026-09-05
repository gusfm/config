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
vim.opt.clipboard = 'unnamed'
vim.opt.number = true

-- Route yanks through OSC 52 when running under tmux or ssh, so they reach the
-- clipboard of the machine the terminal is on. No-op in a plain local session.
require('config.remote_clipboard').setup()

-- Return to the last position in file
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = {"*"},
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end
})

-- Rgrep
vim.opt.grepprg='grep -rn --exclude-dir=.git --exclude-dir=build --exclude=tags --exclude=\\*.{swp,o}'
vim.cmd([[command! -nargs=+ Rgrep execute 'silent grep! <args>' | botright copen | setlocal nobuflisted | redraw!]])
-- Neovim ships grn/gra/gri/grr/grx/grt as default LSP maps; leaving them in
-- place makes plain 'gr' wait out timeoutlen before firing.
for _, lhs in ipairs({ 'grn', 'gra', 'gri', 'grr', 'grx', 'grt' }) do
    pcall(vim.keymap.del, 'n', lhs)
end
vim.keymap.set('n', 'gr', ':Rgrep <cword><CR>', { noremap=true })

-- Keymaps
vim.keymap.set('n', 't', '<c-t>', { noremap=true })
vim.keymap.set('x', 'Y', '"+y', { noremap=true })
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
local function clang_format()
    if vim.fn.executable('clang-format') == 0 then
        return
    end

    local buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buf)
    local cmd = { 'clang-format' }
    if name ~= '' then
        -- Lets clang-format find the .clang-format that applies to this file.
        cmd[#cmd + 1] = '--assume-filename=' .. name
    end

    local input = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local out = vim.fn.systemlist(cmd, input)
    if vim.v.shell_error ~= 0 then
        vim.notify(table.concat(out, '\n'), vim.log.levels.ERROR)
        return
    end

    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
    vim.fn.winrestview(view)
end

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.c', '*.cc', '*.h', '*.hh' },
  callback = clang_format
})
vim.keymap.set('n', '<c-k>', clang_format, { noremap=true })

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
    {
      "nvim-treesitter/nvim-treesitter",
      branch = 'main',
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require('nvim-treesitter').setup()
        require('nvim-treesitter').install({
          'c', 'cpp', 'lua', 'python', 'bash', 'make', 'diff',
          'markdown', 'markdown_inline', 'json', 'yaml', 'vim', 'vimdoc',
        })
        -- The main branch does not start highlighting on its own.
        vim.api.nvim_create_autocmd('FileType', {
          callback = function(ev)
            pcall(vim.treesitter.start, ev.buf)
          end,
        })
      end,
    },
    -- Colorschemes
    {"ellisonleao/gruvbox.nvim"},
    {"tpope/vim-vividchalk"}
  },
})

vim.cmd.colorscheme('gruvbox')
--vim.cmd.colorscheme('vividchalk')
