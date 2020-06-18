" VIM configuration by Dustin Wheeler
" Created 2019-04-16, edited 2019-04-16

"Remove compatibility with Vi
set nocompatible

" Specify plugin directory
call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches https://github.com/altercation/vim-colors-solarized.git
Plug 'altercation/vim-colors-solarized'	" Add Solarized color scheme
Plug 'vim-latex/vim-latex'				" Add Vim-LaTeX for LaTeX support
Plug 'sjbach/lusty'						" Add Lusty Explorer file manager
										" trigger with <Leader>l[frbg]
Plug 'mileszs/ack.vim'					" Add support for Ack (or Ag)

" Any valid git URL is allowed
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
" Enable <Tab> completion and load a default snippets set
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

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

set scrolloff=3		" Display a least 3 lines around the cursor
					" when scrolling
set laststatus=2	" Always display status line
set mouse=a			" Enable mouse in a ll modes
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
" Set Leader key up for  Lusty Explorer, another file browser plugin
let mapleader=","
" Centralize backups, swapfiles, and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif


" Hide buffer (file) instead of abandoning when switching to another buffer
set hidden
" Keep 100 items in history memory
set history=100

" -- Color options
syntax enable

if has("gui_running")
    let g:solarized_termtrans=1
    let g:solarized_termcolors=256
    set background=light
    colorscheme solarized
endif
set guifont=Inconsolata:h13
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

