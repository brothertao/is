"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This vimrc is based on the vimrc by Amix - http://amix.dk/ and http://blog.csdn.net/easwy
" You can find the latest version on: http://code.google.com/p/jvimrc
"
" Maintainer: Moven
" Version: 0.2
" Last Change: 31/05/07 09:17:57
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Functions"
function! MySys()
    if (has("win32") || has("win64") || has("win32unix"))
        return "windows"
    else
        return "linux"
    endif
endfunction

function! CurDir()
 let curdir = substitute(getcwd(), '/home/moven/', "~/", "g")
 return curdir
endfunction

" Switch to buffer according to file name
function! SwitchToBuf(filename)
    "let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
    " find in current tab
    let bufwinnr = bufwinnr(a:filename)
    if bufwinnr != -1
        exec bufwinnr . "wincmd w"
        return
    else
        " find in each tab
        tabfirst
        let tab = 1
        while tab <= tabpagenr("$")
            let bufwinnr = bufwinnr(a:filename)
            if bufwinnr != -1
                exec "normal " . tab . "gt"
                exec bufwinnr . "wincmd w"
                return
            endif
            tabnext
            let tab = tab + 1
        endwhile
        " not exist, new tab
        exec "tabnew " . a:filename
    endif
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  else
    execute "normal /" . l:pattern . "^M"
  endif
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Editing mappings etc.
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  nohl
  exe "normal `z"
endfunc

function! s:GetVisualSelection()
   let save_a = @a
   silent normal! gv"ay
   let v = @a
   let @a = save_a
   let var = escape(v, '\\/.$*')
   return var
endfunction

" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
   let _tags = &tags
   try
       let &tags = eval(g:LookupFile_TagExpr)
       let newpattern = '\c' . a:pattern
       let tags = taglist(newpattern)
   catch
       echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
       return ""
   finally
       let &tags = _tags
   endtry

   " Show the matches for what is typed so far.
   let files = map(tags, 'v:val["filename"]')
   return files
endfunction

function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"general configure
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Get out of VI's compatible mode..
set nocompatible

"Set the enviroment encoding type
set fileencodings=utf-8,ucs-bom,gb18030,cp936,big5,euc-jp,euc-kr,latin1

"pathogen
call pathogen#runtime_append_all_bundles()
"set runtimepath+=C:/vim/vimfiles/vim-plugin-manager 
"call scriptmanager#Activate(["vim-haxe","The_NERD_tree","vim-latex"]) 


"Enable filetype plugin
filetype plugin on
filetype indent on

"Set to auto read when a file is changed from the outside
set autoread

"Have the mouse enabled all the time:
set mouse=a

"Sets how many lines of history VIM har to remember
set history=400

"show command
set showcmd

"marks settings
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let showmarks_enable = 0

"Set 7 lines to the curors - when moving vertical..
set so=7

"Turn on Wild menu
set wildmenu

"Turn off the temp file
set noswapfile

"Always show current position
set ruler

"The commandbar is 2 high
set cmdheight=2

"Show line number
set nu

"Do not redraw, when running macros.. lazyredraw
set lz

"Change buffer - without saving
set hid

"Set backspace
set backspace=eol,start,indent

"Bbackspace and cursor keys wrap to
set whichwrap+=<,>,h,l

"Ignore case when searching
set ignorecase

"Include search
set incsearch

"Highlight search things
set hlsearch

"Set magic on regx
set magic

"php code configure
inoremap <m-c> <ESC>:call PhpDocSingle()<CR>i 
nnoremap <m-c> :call PhpDocSingle()<CR> 
vnoremap <m-c> :call PhpDocRange()<CR> 

map <f5> <esc>:EnableFastPHPFolds<cr>
map <f6> <esc>:EnablePHPFolds<cr>
map <f7> <esc>:DisablePHPFolds<cr>
map <f8> @a
"No sound on errors.
set noerrorbells
set novisualbell

"show the sign of the end of line
"set list
"set listchars=~

"show matching bracets
set showmatch

"set language
language C

"How many tenths of a second to blink
set mat=2

"Always hide the statusline
"set laststatus=2
"set statusline=%l/%L\ \ \ \ \ \ \ %F%m%r%h

"Favorite filetypes
set ffs=unix,dos

"Enable folding, I find it very useful
set fen
set fdl=1

set smarttab
set tabstop=4
set expandtab
set shiftwidth=4

map <leader>t2 :set shiftwidth=2<cr>
map <leader>t4 :set shiftwidth=4<cr>
au FileType html,python,vim,javascript setl shiftwidth=2
au FileType java,c setl shiftwidth=4
au FileType txt setl lbr
au FileType txt setl tw=78

" Vim section
autocmd FileType vim set nofoldenable
autocmd FileType vim map <buffer> <leader><space> :w!<cr>:source %<cr>

"Auto indent
set ai

"Smart indet
set si

"C-style indeting
set cindent

"Wrap lines
set wrap

" Complete options
set completeopt=menu
set complete-=u
set complete-=i

"doxygen-support  comments auto generate

"Platom"
if MySys() == "linux"
  set gfn=Monospace\ 12
else
  source $VIMRUNTIME/mswin.vim
  behave mswin
  set guifont=Monaco:h10
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" shortkey map
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set mapleader
let mapleader = ","
let g:mapleader = ","
"Remap <ESC>
imap ,ww <ESC> :w<cr>
vmap ,ww <ESC> :w<cr>

"Fast saving
nmap <silent> <leader>ww :w<cr>

"Fast quiting
nmap <silent> <leader>qw :wq<cr>
nmap <silent> <leader>qq :q<cr>

"fast insert back
imap <c-g> <esc>i

"fast insert forward
imap <c-f> <esc>la

"Fast remove highlight search
nmap <silent> <space> :noh<cr>

"Fast paste from out
nmap t "+p

"Fast redraw
nmap <silent> <leader>rr :redraw!<cr>

"Show Marks Toggle  :help showmarks
map <silent> <leader>kk :ShowMarksToggle<cr>
nmap <silent> <leader>mk :MarksBrowser<cr>

"filetype:unix|dos
nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>

"Fast edit vimrc
if MySys() == 'linux'
    "Fast reloading of the .vimrc
    map <silent> <leader>ss :source ~/.vimrc<cr>
    "Fast editing of .vimrc
    map <silent> <leader>ee :call SwitchToBuf("~/.vimrc")<cr>
    "When .vimrc is edited, reload it
    autocmd! bufwritepost .vimrc source ~/.vimrc
elseif MySys() == 'windows'
    "Fast reloading of the _vimrc
    map <silent> <leader>ss :source $VIM/_vimrc<cr>
    "Fast editing of _vimrc
    map <silent> <leader>ee :call SwitchToBuf("$VIM/_vimrc")<cr>
    "When _vimrc is edited, reload it
    "autocmd! bufwritepost _vimrc source ~/_vimrc
endif

" Avoid clearing hilight definition in plugins
if !exists("g:vimrc_loaded")
    "Enable syntax hl
    syntax enable

    " color scheme
    if has("gui_running")
        set guioptions-=T
        set guioptions-=m
        set guioptions-=l
        set guioptions+=r
        colorscheme grey2
    else
        colorscheme desert_my
    endif " has
endif " exists(...)

"Some nice mapping to switch syntax (useful if one mixes different languages in one file)
map <leader>1 :set syntax=c<cr>
map <leader>2 :set syntax=xhtml<cr>
map <leader>3 :set syntax=python<cr>
map <leader>4 :set ft=javascript<cr>
map <leader>$ :syntax sync fromstart<cr>

autocmd BufEnter * :syntax sync fromstart

"Highlight current
if has("gui_running")
  set cursorline
  hi cursorline guibg=#333333
  hi CursorColumn guibg=#333333
endif

"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

"Smart way to move btw. windows
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

"Actually, the tab does not switch buffers, but my arrows ,Bclose function can be found in "Buffer related" section
map <leader>bd :Bclose<cr>
"Use the arrows to something usefull
map <right> :bn<cr>
map <left> :bp<cr>
"Open a dummy buffer for paste
map <leader>es :tabnew<cr>:setl buftype=nofile<cr>
if MySys() == "linux"
    map <leader>ec :tabnew ~/tmp/scratch.txt<cr>
else
    map <leader>ec :tabnew $TEMP/scratch.txt<cr>
endif

try
  set switchbuf=useopen
  set showtabline=0
catch
endtry

"Moving fast to front, back and 2 sides ;)
imap <c-e> <esc>$a
nmap <c-e> $
imap <c-a> <esc>0i
nmap <c-a> 0

"Switch to current dir
map <silent> <leader>cd :cd %:p:h<cr>

"My information
iab xdate <c-r>=strftime("%c")<cr>
iab xname Moven Yang
iab xmail BrotherTao@gmail.com

" do not automaticlly remove trailing whitespace
nmap <silent> <leader>ws :call DeleteTrailingWS()<cr>:w<cr>

" Command-line config Bash like
cnoremap <C-A>    <Home>
cnoremap <C-E>    <End>
cnoremap <C-K>    <C-U>


"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()

" Session options
set sessionoptions-=curdir
set sessionoptions+=sesdir

"Turn backup off
set nobackup
set nowb
set noswapfile

" Enable syntax
""if has("autocmd") && exists("+omnifunc")
""  autocmd Filetype *
""        \if &omnifunc == "" |
""        \  setlocal omnifunc=syntaxcomplete#Complete |
""        \endif
""endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   " Super Tab
   "let g:SuperTabDefaultCompletionType = "<C-P>"

   " yank ring setting
   map <leader>yr :YRShow<cr>

   " file explorer setting
   "Split vertically
   let g:explVertical=1
   let g:explWinSize=35
   let g:explSplitLeft=1
   let g:explSplitBelow=1

   "Hide some files
   let g:explHideFiles='^\.,.*\.class$,.*\.swp$,.*\.pyc$,.*\.swo$,\.DS_Store$'

   "Hide the help thing..
   let g:explDetailedHelp=0


   " minibuffer setting
   let loaded_minibufexplorer = 1         " *** Disable minibuffer plugin
   let g:miniBufExplorerMoreThanOne = 2   " Display when more than 2 buffers
   let g:miniBufExplSplitToEdge = 1       " Always at top
   let g:miniBufExplMaxSize = 3           " The max height is 3 lines
   let g:miniBufExplMapWindowNavVim = 1   " map CTRL-[hjkl]
   let g:miniBufExplUseSingleClick = 1    " select by single click
   let g:miniBufExplModSelTarget = 1      " Dont change to unmodified buffer
   let g:miniBufExplForceSyntaxEnable = 1 " force syntax on
   "let g:miniBufExplVSplit = 25
   "let g:miniBufExplSplitBelow = 0

   autocmd BufRead,BufNew :call UMiniBufExplorer

   " bufexplorer setting
   let g:bufExplorerDefaultHelp=1       " Do not show default help.
   let g:bufExplorerShowRelativePath=1  " Show relative paths.
   let g:bufExplorerSortBy='mru'        " Sort by most recently used.
   let g:bufExplorerSplitRight=0        " Split left.
   let g:bufExplorerSplitVertical=1     " Split vertically.
   let g:bufExplorerSplitVertSize = 30  " Split width
   let g:bufExplorerUseCurrentWindow=1  " Open in new window.
   let g:bufExplorerMaxHeight=13        " Max height

   " winmanager setting
   let g:winManagerWindowLayout = "FileExplorer,BufExplorer"
   let g:winManagerWidth = 30
   let g:defaultExplorer = 0
   nmap <C-W><C-F> :FirstExplorerWindow<cr>
   nmap <C-W><C-B> :BottomExplorerWindow<cr>
   nmap <silent> <leader>wm :WMToggle<cr>
   autocmd BufWinEnter \[Buf\ List\] setl nonumber

   " lookupfile setting
   let g:LookupFile_MinPatLength = 2
   let g:LookupFile_PreserveLastPattern = 0
   let g:LookupFile_PreservePatternHistory = 0
   let g:LookupFile_AlwaysAcceptFirst = 1
   let g:LookupFile_AllowNewFiles = 0
   if filereadable("./filenametags")
       let g:LookupFile_TagExpr = '"./filenametags"'
   endif
   nmap <silent> <leader>fk <Plug>LookupFile<cr>
   nmap <silent> <leader>fb :LUBufs<cr>
   nmap <silent> <leader>ff :LUWalk<cr>

   let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'


   " HTML entities - used by xml edit plugin
   let xml_use_xhtml = 1
   "let xml_no_auto_nesting = 1

   "To HTML
   let html_use_css = 1
   let html_number_lines = 0
   let use_xhtml = 1


   " HTML
   au FileType html set ft=xml
   au FileType html set syntax=html

   "fast grep in curbuffer"
   nmap <silent> <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
   vmap <silent> <leader>lv :lv /<c-r>=<sid>GetVisualSelection()<cr>/ %<cr>:lw<cr>

   " Fast diff
   cmap @vd vertical diffsplit
   set diffopt+=vertical

   "Remove the Windows ^M
   noremap <Leader>dm mmHmn:%s/<C-V><cr>//ge<cr>'nzt'm

   "Paste toggle - when pasting something in, don't indent.
   set pastetoggle=<F3>

   "Super paste
   inoremap <C-v> <esc>:set paste<cr>mui<C-R>+<esc>mv'uV'v=:set nopaste<cr>

   "Fast Ex command
   nnoremap ; :
let g:vimrc_loaded = 1
map <C-b> :% ! phpCB  --space-after-if  --space-after-switch --space-after-while --space-before-start-angle-bracket --space-after-end-angle-bracket --one-true-brace-function-declaration --glue-amperscore --change-shell-comment-to-double-slashes-comment --force-large-php-code-tag --force-true-false-null-contant-lowercase --align-equal-statements --comment-rendering-style PEAR --equal-align-position 50 --padding-char-count 4 "%" <CR>
