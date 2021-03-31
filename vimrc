" VIM configuration by Dustin Wheeler
" Created 2019-04-16, edited 2021-03-31

"Remove compatibility with Vi
set nocompatible

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()

" Shorthand notation; fetches https://github.com/mileszs/ack.vim
Plug 'mileszs/ack.vim'					" Add support for Ack (or Ag)
Plug 'scrooloose/nerdcommenter'			" Add support for commenting out lines
Plug 'altercation/vim-colors-solarized'	" Add Solarized color scheme

" Any valid git URL is allowed
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
" Enable <Tab> completion and load a default snippets set
Plug 'vim-scripts/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'vim-latex/vim-latex', { 'for': 'latex' }		" Add LaTeX support
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Initialize plugin system
call plug#end()

"-- Display options

set title 			" Update the title of the window or terminal
set number			" Display line numbers
" Show relative line numbers
if exists("&relativenumber")
	set relativenumber
	augroup numbertoggle
		autocmd!
		autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
		autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
	augroup END
" au BufReadPost * set relativenumber
endif
set ruler			" Display cursor position
set wrap			" Wrap lines when they get too long
set tw=0			" Disable automatic linebreak after col=80
set colorcolumn=80	" Add a colored column as a line-length reminder
set tabstop=4		" Set tabs to 4 spaces of width
set shiftwidth=4	" Set indentation shift to four spaces
set cursorline		" Highlight the current line
set autoindent		" Automatically indent new lines

" Show 'invisble' characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
set showmatch		" Show matching parentheses

set scrolloff=3		" Display a least 3 lines around the cursor when scrolling
set laststatus=2	" Always display status line
set mouse=a			" Enable mouse in all modes
set showmode		" Display the current mode
set title			" Show the filename in the title bar
set showcmd			" Show the (partial) command as it's  being typed
set guioptions=T	" Enable toolbar when using the GUI

" -- Search options
set ignorecase		" Ignore case when searching
set smartcase		" Do case-sensitive searches when an uppercase
					" character is used.
set incsearch		" Highlight search results when typing
set hlsearch		" Highlight search results
" Do incremental searching when it's possible to timeout.
if has ('reltime')
	set incsearch
endif
" Cancel search with Esc
nnoremap <Esc><Esc> :nohlsearch<Bar>:echo<CR> 

" -- Beep options
set visualbell 		" Prevent Vim from beeping
set noerrorbells	" Prevent Vim from beeping

" -- Miscellaneous usability options
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Backspace key behaves as expected
set backspace=indent,eol,start
" Set Leader key up for plugins
" nnoremap <SPACE> <Nop>
let mapleader=","

" Centralize backups, swapfiles, and undo history
if !isdirectory($HOME . "/.vim/backup")
    call mkdir($HOME . "/.vim/backup", "p", 0722)
endif
if !isdirectory($HOME . "/.vim/swaps")
    call mkdir($HOME . "/.vim/swaps", "p", 0722)
endif
if !isdirectory($HOME . "/.vim/undo")
    call mkdir($HOME . "/.vim/undo", "p", 0722)
endif
set backupdir=~/.vim/backup//
set directory=~/.vim/swaps//
if exists("&undodir")
	set undodir=~/.vim/undo//
endif


" Hide buffer (file) instead of abandoning when switching to another buffer
set hidden
" Keep 100 items in history memory
set history=100

" -- Color options
syntax enable

set antialias

" -- Toggle keys

" Toggle NERDTree, enable quit with 'q' when NERDTree is the last window open
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Create shortcut for Ag (if available)
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
	cnoreabbrev ag Ack
	cnoreabbrev aG Ack
	cnoreabbrev Ag Ack
endif
" set shellpipe "&>"

