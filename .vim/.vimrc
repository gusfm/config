" Vim configuration file

"----------------------------------------------------------
" Basic configs
"----------------------------------------------------------
" Use vim instead of vi
set nocompatible
" Set path to recursive search current folder
set path+=**
" Enable wild menu
set wildmenu
" Enables syntax highlighting
syntax enable
" If using a dark background within the editing area
set background=dark
" Jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Load indentation rules and plugins according to the detected filetype.
filetype plugin indent on
" Show (partial) command in status line.
set showcmd
" Show matching brackets.
set showmatch
" Incremental search
set incsearch
" Do not automatically read a file when it was changed by other program
set noautoread
" Automatically save before commands like :next and :make
set autowrite
" Hide buffers when they are abandoned
set hidden
" Enable mouse usage (all modes)
set mouse=a
" Normal backspace
set backspace=indent,eol,start
" Only show status line if there is more that one window open
set laststatus=1
if has('nvim')
    " Use '*' register for copy operations
    set clipboard=unnamed
    " Shows the effects of a command incrementally
    set inccommand=nosplit
endif
" Set tab size to 4 spaces
set shiftwidth=4 tabstop=4
" Make vim use spaces instead of tabs
set expandtab
" Auto indentation
set autoindent
" Get the amount of indent for line according the C indenting rules
set cindent
" Enable highlight search
set hlsearch
" Tags directory
set tags=/usr/include/tags,tags
" A comma separated list of word list names.
"set spelllang=pt
set spelllang=en
" Config :grep
let &grepprg='grep -rn --exclude-dir=.git --exclude-dir=build --exclude=tags --exclude=\*.{swp,o}'
" Create the Rgrep command
command! -nargs=+ Rgrep execute 'silent grep! <args>' | botright copen | setlocal nobuflisted | redraw!
" Search for word under cursor
nnoremap gr :Rgrep <cword><CR>

"----------------------------------------------------------
" Maps
"----------------------------------------------------------
" Map return from tag to 't'
noremap t <c-t>
" Toggle spell check
nmap \s :set spell!<CR>
" Toggle line numbers
nmap \l :setlocal number!<CR>
" Togle set paste
nmap \o :set paste!<CR>
" Toggle scroll bind
nmap \b :set scb!<CR>
"jump accordingly to lines on the screen
noremap j gj
noremap k gk
" Next buffer
nnoremap <Tab> :bnext<CR>
" Previous buffer
nnoremap <S-Tab> :bprevious<CR>

"----------------------------------------------------------
" Plugin configs
"----------------------------------------------------------
" vim-plug
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'tpope/vim-vividchalk'
call plug#end()

" Clang format
map <C-K> :py3f /usr/share/vim/addons/syntax/clang-format.py<cr>

" Indent when saving
function! ExecuteClangAutoFormat()
    %py3f /usr/share/vim/addons/syntax/clang-format.py
endfunction
autocmd BufWritePre *.c,*.cc,*.h,*.hh call ExecuteClangAutoFormat()

"----------------------------------------------------------
" Application configs
"----------------------------------------------------------
colorscheme vividchalk
if has('gui_running')
    " Configs for gvim
    " Remove menu bar, tabs, toolbar, left and right hand scroll bar
    set guioptions-=m
    set guioptions-=e
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    " Set font
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 11
    hi Search guibg=orange guifg=black
    hi DiffAdd      gui=none    guifg=#00f000   guibg=#101010
    hi DiffChange   gui=none    guifg=NONE      guibg=#101010
    hi DiffDelete   gui=bold    guifg=#f00000   guibg=#101010
    hi DiffText     gui=none    guifg=#00f000   guibg=#101010
else
    hi Search ctermbg=214 ctermfg=0
endif
