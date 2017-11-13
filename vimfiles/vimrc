" use VIM settings instead of VI
set nocompatible

" pathogen plugin helper
call pathogen#infect()
call pathogen#helptags()

" load filetype plugins and indentation
filetype plugin indent on

" turn on syntax highlighting after enabling ftplugins
syntax enable

set background=dark


" in mintty (git bash for windows) only one cursor type was being displayed
" these fix it
" https://github.com/mintty/mintty/wiki/Tips#mode-dependent-cursor-in-vim
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

" in terminal vim, pressing Esc was taking forever to exit insert mode
" and go back to normal mode. this fixes it
set ttimeout
set ttimeoutlen=50


" color scheme

" my jellybeans mods for lower contrast
let g:jellybeans_overrides = {
\    'background': { 'guibg': '2c2c2c' },
\    'Normal': { 'guifg': 'cccccc' },
\    'Statement': { 'guifg': '8DA8FF', 'guibg': '',
\              'ctermfg': 'DarkBlue', 'ctermbg': '',
\              'attr': '' },
\    'Visual': { 'guifg': '', 'guibg': '505050',
\              'ctermfg': '', 'ctermbg': 'Black',
\              'attr': '' },
\    'CursorLine': { 'guifg': '', 'guibg': '303030',
\              'ctermfg': '', 'ctermbg': 'Black',
\              'attr': '' },
\    'ColorColumn': { 'guifg': '', 'guibg': '303030',
\              'ctermfg': '', 'ctermbg': 'Black',
\              'attr': '' },
\    'CursorLineNr': { 'guifg': '8F8A89', 'guibg': '2c2c2c',
\              'ctermfg': 'Black', 'ctermbg': '',
\              'attr': 'none' },
\    'Special': { 'guifg': '8abeb7', 'guibg': '',
\              'ctermfg': 'Green', 'ctermbg': '',
\              'attr': '' },
\    'LineNR': { 'guifg': '4d4848' },
\}

" set gui size and font
if has("gui_running")
  colorscheme jellybeans
  set columns=120
  set lines=35
  if has("gui_gtk2")    " or has('unix')
    set guifont=Inconsolata\ 12
  elseif has("gui_win32")
    " set guifont=Inconsolata:h13
    " set guifont=DejaVu\ Sans\ Mono:h12
    set guifont=Consolas:h11
  endif
elseif has("unix")
  colorscheme jellybeans
endif


" auto indent from the previous line
set autoindent

" set tabs = 8 spaces
set tabstop=8

" indentation is 3 spaces
set shiftwidth=3

" expand tab presses into spaces
set expandtab

" tab keypress at the start of lines use shiftwidth instead of tabstop
" tab keypress mid-line use tabstop
set smarttab

" allow backspace to work normally
set backspace=indent,eol,start

" show line,column numbers at bottom
set ruler

" show line number on left
set number

" show line number offsets from current line
set relativenumber

" dont auto break lines after a certain number of chars
" can always check where this value was changed with :verbose set tw?
set textwidth=0


" word wrap long lines
set wrap

" wrap at word boundary
set linebreak

" show char on wrapped lines
if exists('+breakindent')
   set breakindent
   set breakindentopt=sbr
   :let &showbreak = '> '
endif

" if wrapping is ever toggled off, scroll normally
set sidescroll=1

" show lines instead of @ symbols if they don't fit
set display+=lastline

" show which mode vim is in
set showmode

" disable cursor blinking in normal and visual mdoes
" blink fast in insert mode
set guicursor+=n-v:blinkon0,i-ci:ver25-Cursor/lCursor-blinkwait100-blinkoff250-blinkon200

" dont show the toolbar or menu in GVIM
set guioptions-=T
set guioptions-=m

" highlight the line that the cursor is on
set cursorline

" Only show cursorline in the current window
" and not in insert mode
augroup cline
    autocmd!
    autocmd WinLeave,InsertEnter * set nocursorline
    autocmd WinEnter,InsertLeave * set cursorline
augroup END

" blink screen on error instead of beeping
set visualbell

" show filename in titlebar of terminals
set title

" bigger history
set history=1000

" default to windows file format
set fileformats=dos,unix

" '-options' : dont save keymappings when saving a session, also don't save
"             runtimepath for pathogen
" but do save window size and pos
set sessionoptions-=options
set sessionoptions+=winpos,resize

" hide buffers instead of closing them
set hidden

" highlight search results
"set hlsearch

" show search matches as you type
set incsearch

" make searches case insensitive
set ignorecase

" unless the search contains one capital
set smartcase

" move backup and swap files to a different directory to not clutter working dirs
set backup
if has("unix")
   set backupdir=~/.vim/backup
   set directory=~/.vim/swap//
else
   set backupdir=~/vimfiles/backup
   set directory=~/vimfiles/swap//
endif

" from :help 'directory'
"- For Unix and Win32, if a directory ends in two path separators "//"
"  or "\\", the swap file name will be built from the complete path to
"  the file with all path separators substituted to percent '%' signs.
"  This will ensure file name uniqueness in the preserve directory.

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif


" when typing a closing brace, briefly show matching opening
set showmatch

" show matching brace for 0.2s
set matchtime=2

" match angle brackets for HTML
set matchpairs+=<:>

" if using Ctrl+A to increment, dont handle numbers starting with 0 as octal (:h nrformats)
set nrformats-=octal

" Don't add the comment prefix when I hit enter or o/O on a comment line.
" http://tilvim.com/2013/12/30/remove-comment-prefix-2.html
autocmd FileType * setlocal formatoptions-=ro

" from vimrc_example.vim, see also :help last-position-jump
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
 \ if line("'\"") > 1 && line("'\"") <= line("$") |
 \   exe "normal! g`\"" |
 \ endif

" open new window splits on bottom or right instead of top or left
set splitbelow
set splitright

" show some padding lines when scrolling with <c-f> <c-b> or jk
set scrolloff=2

" use unicode format within vim
set encoding=utf-8

" attempt to read files in these formats in order
" use cp1252 ahead of latin1 because my files use euro and pound currecy symbols
set fileencodings=ucs-bom,utf-8,cp1252,latin1

" fast terminal drawing
set ttyfast

" always show the statusline
set laststatus=2

" set folding method
set foldmethod=indent
" open all folds by default
"   dont use nofoldenable:
"     http://superuser.com/questions/169973/vim-enable-folds-but-dont-automatically-close-them#comment343818_171716
"   instead use autocmd zR
autocmd BufWinEnter * normal zR

" convert using \ for directory nav to / so windows behaves like unix
" but this messes up some plugins? and vim seems to allow / for windows dirs
" set shellslash

" show tab and trailing whitespace
"set listchars=tab:>~,trail:·
set listchars=tab:>~
set list

" display trailing whitespace as a highlighted error only after some text
" the 'trail' listchar matches lines with only whitespace
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
" match ErrorMsg '\(\S\+\)\@<=\s\+$'
" shorter:
" match ErrorMsg '\S\zs\s\+$'

" allow moving to cursor to locations without text only in visual block mode
set virtualedit=block

" show partial command as typed
set showcmd

" popup completion menu max display 10 items
set pumheight=10

" auto complete vim commandline
set wildmenu
set wildmode=longest,full

" allow omni-completion to use syntax file keywords for langs without omnifunc
set omnifunc=syntaxcomplete#Complete

" long lines cause vim to slowdown due to syntax highlighting
set synmaxcol=200

" allow % motion to jump to matching if/else branches as well
" not using right now because i would need to define b:matchwords for AHK
" see macros/matchit.txt for help
" runtime macros/matchit.vim

" mappings ---------------------------------------------

" yankstack requires that its mappings be done first so that it doens't
" overwrite mappings below
call yankstack#setup()

" move by visual lines on the screen (would normally jump over wrapped lines)
" unless preceeded by a count, then use regular movement so we can use
" the relativenumber setting
" https://bluz71.github.io/2017/05/15/vim-tips-tricks.html
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
" do map the arrows to move by screen lines since I'm never using a count with arrows
nnoremap <up> gk
nnoremap <down> gj
inoremap <up> <C-o>gk
inoremap <down> <C-o>gj


" center the screen after 'finding next' occurence and open folds
nnoremap n nzzzv
nnoremap N Nzzzv


" easier navigation to the start/end of lines
noremap H ^
noremap L $
vnoremap L g_


" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" remap CTRL+E to move to end of line
inoremap <C-E> <End>


" Make Y behave like C and D
" by default Y would normally act the same as yy
nnoremap Y y$


" in insert mode, allow ctrl+backspace to delete prev word as in normal editors
" http://vim.wikia.com/wiki/Map_Ctrl-Backspace_to_delete_previous_word
imap <C-BS> <C-w>

" in insert mode, make Shift+Tab un-indent a line
" insert mode already has CTRL+T and CTRL+D to indent/unindent
" alternatively can use   inoremap <S-Tab> <C-O><<
" http://vim.wikia.com/wiki/Shifting_blocks_visually
inoremap <S-Tab> <C-d>

" also toggle search highlighting with CTRL+L
nnoremap <C-L> <C-L>:set hlsearch! hlsearch?<CR>

" Stop that damn ex mode, I don't know what it is and don't use it
" or perhaps map this to playback a macro as suggeted here:
" http://hashrocket.com/blog/posts/8-great-vim-mappings
nnoremap Q <nop>

" execute current file in buffer
" http://vim.wikia.com/wiki/Execute_external_programs_asynchronously_under_Windows
"nnoremap <F5> :!"%:p"<CR><CR>
" windows version which doesn't block the editor:
nnoremap <F5> :!start cmd.exe /c "%:p"<CR><CR>

" Use CTRL-S for saving, also in Insert mode
" on Linux terminal, CTRL+S hangs the terminal, so a bash setting is required:
" http://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <ESC>:update<CR>

" when using > to indent in visual mode, re-select the previously selected area
" this allows multiple >>>> indents back to back
vnoremap < <gv
vnoremap > >gv


" http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
" big fuck you to VIM. this is the most annoying thing ever
" maybe i should do this:
"                         nnoremap d "_d
"                         nnoremap <leader>d d
" dont even need <leader>d since i can just visually select and use 'x'
" that way i can use 'd' to truly delete
" or use    nnoremap <leader>d "_d
"vnoremap p "_dP
" ^seems yankstack handles this
" really i should just use visual mode to paste over


" from vimrc_example.vim, see also :help :DiffOrig
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the unsaved changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


" indicate when width >= 81 chars
"set colorcolumn=81

" toggle colorcolumn
function! g:ToggleColorColumn()
  if &colorcolumn != ''
    setlocal colorcolumn&
  else
    setlocal colorcolumn=81
  endif
endfunction
 
nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<CR>


" plugin settings ---------------------------


" turn off indentlines by default
let g:indentLine_enabled = "0"

nnoremap <leader>il :IndentLinesToggle<CR>

nnoremap <leader>rp :RainbowParenthesesToggleAll<CR>


" lightline statusbar settings
" don't show certain settings when window width is too narrow

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'component_function': {
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \ },
      \ }

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction



" don't autoclose the ` char in AHK scripts
"call smartinput#define_rule({
" \   'at': '\%#',
" \   'char': '`',
" \   'input': '`',
" \   'filetype': ['autohotkey'],
" \ })




" experimenting with completion functions

fun! CompleteMonths(findstart, base)
   if a:findstart
      " locate the start of the word
      let line = getline('.')
      let start = col('.') - 1
      while start > 0 && line[start - 1] =~ '\a'
         let start -= 1
      endwhile
      return start
   else
      " find months matching with "a:base"
      let matches = []
      let all_values = {
               \ 'Jan': 'January',
               \ 'Feb': 'February',
               \ 'Mar': 'March',
               \ 'Apr': 'April',
               \ 'May': 'May',
               \ 'Jun': 'June',
               \ 'Jul': 'July',
               \ 'Aug': 'August',
               \ 'Sep': 'September',
               \ 'Oct': 'October',
               \ 'Nov': 'November',
               \ 'Dec': 'December',
               \ }
      for m in sort(keys(all_values))
         if m =~ '^' . a:base
            call add(matches, m)
         endif
      endfor

      let final_list = []
      for i in matches
         let final_list += [{
                  \ 'word': i,
                  \ 'info': i.':::'.all_values[i],
                  \ 'menu': all_values[i], 
                  \ 'kind': 'month',
                  \ }]
      endfor

      return final_list
   endif
endfun

" completefunc for user defined complettion <C-X><C-U>
set completefunc=CompleteMonths

