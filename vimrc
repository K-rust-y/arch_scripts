filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'scrooloose/nerdtree.git'
Plugin 'rust-lang/rust.vim'
Plugin 'rust-lang-nursery/rustfmt'
Plugin 'micha/vim-colors-solarized'
Plugin 'godlygeek/tabular'
call vundle#end()
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'vim-syntastic/syntastic'
Plugin 'rust-lang/rust.vim'
Plugin 'rust-lang-nursery/rustfmt'	
" Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree.git'
Plugin 'micha/vim-colors-solarized'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
call vundle#end()            

" Basic Behavior

syntax enable
filetype plugin indent on

set number              " show line numbers
set wrap                " wrap lines
set encoding=utf-8      
set showmatch           
set ruler               " show line and column number of the cursor on right side of statusline

set termguicolors     " enable true colors support

set autoindent          " copy indent from current line when starting a new line
"set smartindent         " even better autoindent (e.g. add indent after '{')

set tabstop=4           " number of spaces per <TAB>
set shiftwidth=4
set hlsearch            " Highlight regex

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"tab navigation
nnoremap <C-x> :tabprevious<CR>
nnoremap <C-c> :tabnext<CR>

"Nerdtree open all tabs
autocmd BufWinEnter * NERDTreeMirror

" Change Cursor size
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Autoformat when saving
let g:rustfmt_autosave = 1

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

