map <F2> :NERDTreeToggle<CR>

"" Sean's custom options

if has("win32")
	source $VIMRUNTIME/mswin.vim
	behave mswin
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if has("gui_running")
	" No toolbar on window
	set guioptions-=T

	" Very nice color scheme I found online
	colorscheme wombat

	" A nice, big font to keep my eyes healthy
	if has("win32")
		" set guifont=Lucida_Console:h10:cANSI
		set guifont=Consolas:h11:cDEFAULT
	else " i.e. Mac
		set guifont=DejaVu\ Sans\ Mono:h18

		"set fu

		" Use standard Mac shortucts to switch tabs
		"macm Window.Select\ Previous\ Tab  key=<D-S-Left>
		"macm Window.Select\ Next\ Tab	   key=<D-S-Right>	
	endif

	" Open the window maximized
	" In the future, may want to use fullscreen opt if Mac
	set lines=50 columns=100

	" Keep a few lines after the current for context
	set scrolloff=2
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
	" If I'm opening a session file, automatically source it
	"autocmd BufReadPost *.vis :so %

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

	" Add line numbers to ruby files
	autocmd FileType cucumber,rspec,ruby set number

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
else
	set autoindent		" always set autoindenting on
endif " has("autocmd")

" Change ridiculous 8-wide tabs
set tabstop=2 shiftwidth=2 noexpandtab

" Search: if all lowercase, ignore case; otherwise, match exact
set incsearch
set ignorecase smartcase

" Save sessions
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,resize,winpos,unix,slash
",localoptions

"	Keep processing tags even when tag window is closed
"	let Tlist_Process_File_Always = 1

" snipMate options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Author name is used in some snippets
let g:snips_author = 'Gabriel D. Cook'

" Autocomplete options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Improve autocomplete menu color
highlight Pmenu gui=bold

" For AutoComplPop to find Snips; see http://www.vim.org/scripts/script.php?script_id=1879
let g:acp_behaviorSnipmateLength = 1

" Only complete to the longest match; see http://vim.wikia.com/wiki/VimTip1228
set completeopt+=longest

" Better completion for command-line e.g. filenames
set wildmode=list:longest

" Allow spaces in file names:
" I disabled this because it causes weird behavior - Vim has no idea where the
" file name begins and ends
" See http://vim.wikia.com/wiki/Open_file_under_cursor
"set isfname+=32

" Automatically save a file (buffer) when switching to another
" http://vimdoc.sourceforge.net/htmldoc/vimfaq.html
" set autowriteall

" Use rake to compile programs, instead of the default make
set makeprg=rake

" Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Send Ex command output to new tab
" Example usage: TabMessage highlight
function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  tabnew
  silent put=message
  set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

" Key bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Exit insert mode
" See http://vim.wikia.com/wiki/VimTip285 for ideas
":imap ii <Esc> would be most intuitive (i to enter mode, and ii to exit)
" Two semicolons are easy to type.
" Whatever mapping I chose, I want it to work in both normal and insert mode
" I also want the default normal/command :w to work in insert mode
" This way, either sequence (mine or the default) will work anywhere
inoremap jj <Esc>
inoremap ;; <Esc>:w<CR>
"inoremap jj <Esc>:w<CR>
nnoremap <Space>; :w<CR>
"inoremap :w <Esc>:w<CR>

nnoremap <Space>rf :ruby $f_pin.run_features<CR>

" Switch file in current window
" See http://vim.wikia.com/wiki/Easier_buffer_switching "buffer<Space>
nnoremap <Space>o :buffers<CR>:edit<Space>#

" Move between tabs like other Mac programs
" Didn't work, used keyboard system preferences instead
":macm Window.Select\ Previous\ Tab  key=<D-Left>
":macm Window.Select\ Next\ Tab	    key=<D-Right>

" Configurations

" edit my .vimrc file
nnoremap <Space>e :e %<CR>

":echo 'vimrc reloaded'<CR> " update the system settings from my vimrc file
nnoremap <silent> <Space>p :source ~/.vimrc<cr>:echo 'custom configs reloaded'<CR>

" Comment bindings: see $VIM/vimfiles/plugin/NERD_commenter.vim line 3075+

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

