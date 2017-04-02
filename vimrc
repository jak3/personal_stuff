"-------------------------------------------------------------------------------
" .vimrc made from Derek Wyatt's template. Visit him site derekwyatt.org if you
" love vim. Have a look at github.com/tpope too
"
" (jake)
" License       : GPLv3
"-------------------------------------------------------------------------------

if &compatible
  set nocompatible               " Be iMproved
  filetype off
endif

" Section: Vundle {{{

" set the runtime path to include Vundle and initialize
" Required:
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Theme
Plugin 'bling/vim-airline'
Plugin 'chriskempson/base16-vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'crusoexia/vim-dracula'
Plugin 'vim-airline/vim-airline-themes'

" Generic
Plugin 'junegunn/vim-easy-align'
Plugin 'majutsushi/tagbar'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-abolish'
Plugin 'vim-scripts/VisIncr'
Plugin 'mileszs/ack.vim'
Plugin 'junegunn/vim-peekaboo'
Plugin 'xolox/vim-easytags'

" Code
Plugin 'KabbAmine/zeavim.vim'
Plugin 'SirVer/ultisnips'
Plugin 'Valloric/YouCompleteMe'
Plugin 'honza/vim-snippets'
Plugin 'scrooloose/syntastic'

" Languages
Plugin 'lukerandall/haskellmode-vim'
Plugin 'suan/vim-instant-markdown'
Plugin 'xolox/vim-lua-ftplugin'
Plugin 'xolox/vim-misc' " dependence of vim-lua-ftplugin and easytags
Plugin 'Rykka/riv.vim'
Plugin 'mustache/vim-mustache-handlebars'

" Testing
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'lervag/vimtex'
"Plugin 'vim-scripts/c.vim'

" Personal
Plugin 'jak3/potion'

call vundle#end()
filetype plugin indent on

" }}}

" Section: Options {{{

set completeopt=longest,menuone
set wildmode=list:longest,list:full
set shell=zsh

let mapleader = ","

let g:main_font = "Monospace\\ 9"
let g:small_font = "Monospace\\ 2"

set pastetoggle=<F11>
" undodir file only to /tmp
set undofile
set undodir=/tmp/undo
set undolevels=1000
set undoreload=10000

" backup file only to /tmp
set backupdir-=.
set backupdir^=/tmp/filebackups

" Tabstops are 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent " Should be before expandtab or '>' '<'
set expandtab  " indent commands does not work properly

" Printing options
set printoptions=header:0,paper:letter
" set the search scan to wrap lines
set wrapscan
" I'm happy to type the case of things. I tried the ignorecase, smartcase
" thing but it just wasn't working out for me
set noignorecase

" set the forward slash to be the slash of note. Backslashes suck
set shellslash
if has("unix")
    set shell=bash
else
    set shell=zsh.exe
endif

" Highlight the current line and column
" set nocursorline
set nocursorcolumn
" Make command line two lines high
set ch=2
" set visual bell -- i hate that damned beeping
set vb
" Allow backspacing over indent, eol, and the start of an insert
set backspace=2
" Make sure that unsaved buffers that are to be put in the background are
" allowed to go in there (ie. the "must save first" error doesn't come up)
set hidden
" Make the 'cw' and like commands put a $ at the end instead of just deleting
" the text and replacing it
set cpoptions=ces$
" Set the status line the way i like it
set stl=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]
" tell VIM to always put a status line in, even if there is only one window
set laststatus=2
" Don't update the display while executing macros
set lazyredraw
" Don't show the current command in the lower right corner. In OSX, if this is
" set and lazyredraw is set then it's slow as molasses, so we unset this
set showcmd
" Show the current mode
set showmode
" Show brackets matching
set showmatch
" Hide the mouse pointer while typing
set mousehide
" Set up the gui cursor to look nice
set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
" set the gui options the way I like
set guioptions=acg

" Setting this below makes it show that error messages don't disappear after one second on startup.
"set debug=msg
" This is the timeout used while waiting for user input on a multi-keyed macro
" or while just sitting and waiting for another key to be pressed measured
" in milliseconds.
"
" i.e. for the ",d" command, there is a "timeoutlen" wait period between the
" "," key and the "d" key. If the "d" key isn't pressed before the
" timeout expires, one of two things happens: The "," command is executed
" if there is one (which there isn't) or the command aborts.
set timeoutlen=800
" Keep some stuff in the history
set history=100
" These commands open folds
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo
" Max nested fold
set foldnestmax=4
" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
set scrolloff=8
" Allow the cursor to go in to "invalid" places
set virtualedit=all
" Disable encryption (:X)
set key=
" Make the command-line completion better
set wildmenu
" Make it easier to complete buffers, open files, etc...
set wildignorecase
" dictionary for english words
set dictionary=/usr/share/dict/*
" Same as default except that I remove the 'u' option
set complete=.,w,b,t,i,d
" When completing by tag, show the whole tag, not just the function name
set showfulltag
" Set the textwidth to be 80 chars
set textwidth=80
" Add ignorance of whitespace to diff
set diffopt+=iwhite
" Enable search highlighting
set hlsearch
" Incrementally match the search
set incsearch
" Add the unnamed register to the clipboard
set clipboard+=unnamed
" Automatically read a file that has changed on disk
set autoread

set grepprg=grep\ -nH\ $*

" set left number column hybrid mode
set relativenumber
set number

" set list charactes
set listchars=tab:>\ ,trail:-,nbsp:+,space:‿,eol:$

" Do not resize windows size after close cwindow
set noequalalways

" }}}

" Section: Coding, makeprg and tags {{{

" Let the syntax highlighting for Java files allow cpp keywords
let java_allow_cpp_keywords = 1

nmap <Leader>ma :set makeprg=gcc\\ -Wall\\ -ggdb3\\ -o\\ %<\\ %
nmap <Leader>mx :set makeprg=g++\\ -Wall\\ -O3\\ -std=c++11\\ -fopenmp\\ -lstdc++\\ -lm\\ -o\\ %<\\ %
nmap <Leader>mo :set makeprg=gcc\\ -Wall\\ -O3\\ -std=c11\\ -fopenmp\\ -o\\ %<\\ %
nmap <Leader>m+ :set makeprg=g++\\ -g3\\ -ggdb\\ -O0\\ -Wall\\ -Wextra\\ -Wno-unused\\ -o\\ %<\\ %\\ -lcryptopp
nmap <Leader>mt :set makeprg=gcc\\ -Wall\\ -std=c11\\ -ggdb3\\ -o\\ /tmp/%<\\ %
nmap <Leader>m6 :set makeprg=/opt/mingw-w64-x86_64/bin/x86_64-w64-mingw32-gcc\\ -m32\\ -o\\ %<.exe\\ %
nmap <Leader>mw :set makeprg=/opt/mingw-w64-i686/bin/i686-w64-mingw32-gcc\\ -o\\ %<.exe\\ %

" tags
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" }}}

" Section: mapping {{{
" Wipe out all buffers
nmap <silent> <Leader>wa :1,9000bwipeout<cr>

" Toggle paste mode
nmap <silent> <Leader>p :set invpaste<CR>:set paste?<CR>

" Yank to clipboard
map <Leader>y "+y

" cd to the directory containing the file in the buffer
nmap <silent> <Leader>cd :lcd %:h<CR>
nmap <silent> <Leader>md :!mkdir -p %:p:h<CR>

" Turn off that stupid highlight search
nmap <silent> <Leader>n :nohls<CR>

" Show all available VIM servers
nmap <silent> <Leader>ss :echo serverlist()<CR>

" The following beast is something i didn't write... it will return the
" syntax highlighting group that the current "thing" under the cursor
" belongs to -- very useful for figuring out what to change as far as
" syntax highlighting goes.
nmap <silent> <Leader>qq :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" set text wrapping toggles
nmap <silent> <Leader>ww :set invwrap<CR>:set wrap?<CR>

" Maps to make handling windows a bit easier
noremap <silent> <Leader>cj :wincmd j<CR>:close<CR>
noremap <silent> <Leader>ck :wincmd k<CR>:close<CR>
noremap <silent> <Leader>ch :wincmd h<CR>:close<CR>
noremap <silent> <Leader>cl :wincmd l<CR>:close<CR>
noremap <silent> <Leader>cc :close<CR>
noremap <silent> <Leader>cw :cclose<CR>
noremap <silent> <Leader>ml <C-W>L
noremap <silent> <Leader>mk <C-W>K
noremap <silent> <Leader>mh <C-W>H
noremap <silent> <Leader>mj <C-W>J

" Maps to make handling buffer a bit easier
noremap <silent> <C-n> :bn<CR>
noremap <silent> <C-p> :bp<CR>

" Edit the vimrc file
nmap <silent> <Leader>ev :e $MYVIMRC<CR>
nmap <silent> <Leader>sv :so $MYVIMRC<CR>

" Make horizontal scrolling easier
nmap <silent> <C-o> 10zl
nmap <silent> <C-i> 10zh

" Add a GUID to the current line
imap <C-J>d <C-r>=substitute(system("uuidgen"), '.$', '', 'g')<CR>

" Search the current file for what's currently in the search register and display matches
nmap <silent> <Leader>gs :vimgrep /<C-r>// %<CR>:ccl<CR>:cwin<CR><C-W>J:nohls<CR>

" Search the current file for the word under the cursor and display matches
nmap <silent> <Leader>gw :vimgrep /<C-r><C-w>/ %<CR>:ccl<CR>:cwin<CR><C-W>J:nohls<CR>

" Search the current file for the WORD under the cursor and display matches
nmap <silent> <Leader>gW :vimgrep /<C-r><C-a>/ %<CR>:ccl<CR>:cwin<CR><C-W>J:nohls<CR>

" Spellcheck
nmap <silent> <Leader>S :w!<cr>:!aspell check %<cr>:e! <cr>

" Swap two words
nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

" Underline the current line with '='
nmap <silent> <Leader>u3 :t.\|s/./#/g\|:nohls<cr>

" Underline the current line with '='
nmap <silent> <Leader>uL :t.\|s/./=/g\|:nohls<cr>

" Underline the current line with '-'
nmap <silent> <Leader>ul :t.\|s/./-/g\|:nohls<cr>

" Underline the current line with '~'
nmap <silent> <Leader>ut :t.\|s/./\\~/g\|:nohls<cr>

" Shrink the current window to fit the number of lines in the buffer. Useful
" for those buffers that are only a few lines
nmap <silent> <Leader>sw :execute ":resize " . line('$')<cr>

" Insert current date
nmap <silent> <Leader>cu "=strftime("%c")<cr>P

" Use the bufkill plugin to eliminate a buffer but keep the window layout
nmap <Leader>bd :bd<cr>

" Swap between most recent buffers
nmap <Tab> :b#<CR>

" Alright... let's try this out
imap jj <esc>

"Substitude word under cursor (%s///g)
nnoremap <Leader>s :%s/<C-r><C-w>//g<Left><Left>

" Clear the text using a motion / text object and then move the character to the
" next word
function! ClearText(type, ...)
let sel_save = &selection
let &selection = "inclusive"
let reg_save = @@
if a:0 " Invoked from Visual mode, use '< and '> marks
silent exe "normal! '<" . a:type . "'>r w"
elseif a:type == 'line'
silent exe "normal! '[V']r w"
elseif a:type == 'line'
silent exe "normal! '[V']r w"
    elseif a:type == 'block'
      silent exe "normal! `[\<C-V>`]r w"
    else
      silent exe "normal! `[v`]r w"
    endif
    let &selection = sel_save
    let @@ = reg_save
endfunction
nmap <silent> <Leader>C :set opfunc=ClearText<CR>g@
vmap <silent> <Leader>C :<C-U>call ClearText(visual(), 1)<CR>

if executable('ag')
    " Note we extract the column as well as the file and line number
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m
endif

if !exists('g:bufferJumpList')
    let g:bufferJumpList = {}
endif

function! MarkBufferInJumpList(bufstr, letter)
    let g:bufferJumpList[a:letter] = a:bufstr
endfunction

function! JumpToBufferInJumpList(letter)
    if has_key(g:bufferJumpList, a:letter)
        exe ":buffer " . g:bufferJumpList[a:letter]
    else
        echoerr a:letter . " isn't mapped to any existing buffer"
    endif
endfunction

function! ListJumpToBuffers()
    for key in keys(g:bufferJumpList)
        echo key . " = " . g:bufferJumpList[key]
    endfor
endfunction

function! IndentToNextBraceInLineAbove()
    :normal 0wk
    :normal "vyf(
    let @v = substitute(@v, '.', ' ', 'g')
    :normal j"vPl
endfunction

nmap <silent> <Leader>ii :call IndentToNextBraceInLineAbove()<cr>

nmap <silent> <Leader>mba :call MarkBufferInJumpList(expand('%:p'), 'a')<cr>
nmap <silent> <Leader>mbb :call MarkBufferInJumpList(expand('%:p'), 'b')<cr>
nmap <silent> <Leader>mbc :call MarkBufferInJumpList(expand('%:p'), 'c')<cr>
nmap <silent> <Leader>mbd :call MarkBufferInJumpList(expand('%:p'), 'd')<cr>
nmap <silent> <Leader>mbe :call MarkBufferInJumpList(expand('%:p'), 'e')<cr>
nmap <silent> <Leader>mbf :call MarkBufferInJumpList(expand('%:p'), 'f')<cr>
nmap <silent> <Leader>mbg :call MarkBufferInJumpList(expand('%:p'), 'g')<cr>
nmap <silent> <Leader>jba :call JumpToBufferInJumpList('a')<cr>
nmap <silent> <Leader>jbb :call JumpToBufferInJumpList('b')<cr>
nmap <silent> <Leader>jbc :call JumpToBufferInJumpList('c')<cr>
nmap <silent> <Leader>jbd :call JumpToBufferInJumpList('d')<cr>
nmap <silent> <Leader>jbe :call JumpToBufferInJumpList('e')<cr>
nmap <silent> <Leader>jbf :call JumpToBufferInJumpList('f')<cr>
nmap <silent> <Leader>jbg :call JumpToBufferInJumpList('g')<cr>
nmap <silent> <Leader>ljb :call ListJumpToBuffers()<cr>

function! RunSystemCall(systemcall)
    let output = system(a:systemcall)
    let output = substitute(output, "\n", '', 'g')
    return output
endfunction

function! HighlightAllOfWord(onoff)
    if a:onoff == 1
        :augroup highlight_all
            :au!
            :au CursorMoved * silent! exe printf('match Search /\<%s\>/', expand('<cword>'))
        :augroup END
    else
        :au! highlight_all
        match none /\<%s\>/
    endif
endfunction
:nmap <Leader>ha :call HighlightAllOfWord(1)<cr>
:nmap <Leader>hA :call HighlightAllOfWord(0)<cr>

function! LengthenCWD()
let cwd = getcwd()
    if cwd == '/'
        return
    endif
let lengthend = substitute(cwd, '/[^/]*$', '', '')
    if lengthend == ''
        let lengthend = '/'
    endif
    if cwd != lengthend
exec ":lcd " . lengthend
endif
endfunction
:nmap <Leader>ld :call LengthenCWD()<cr>

function! MakeShellcodeFromOpcode()
    silent! %s/ //g
    silent! %s/  //g
    silent! %s/\t//g
    silent! s/\(\(.\)\(.\)\)/\\x\1/g
endfunction
:nmap <Leader>sh :call MakeShellcodeFromOpcode()<cr>

function! ShortenCWD()
let cwd = split(getcwd(), '/')
let filedir = split(expand("%:p:h"), '/')
    let i = 0
    let newdir = ""
    while i < len(filedir)
        let newdir = newdir . "/" . filedir[i]
        if len(cwd) == i || filedir[i] != cwd[i]
            break
        endif
        let i = i + 1
    endwhile
    exec ":lcd /" . newdir
endfunction
:nmap <Leader>sd :call ShortenCWD()<cr>


" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf("EOF vim: set ts=%d sw=%d tw=%d foldmethod=%s :",
        \ &tabstop, &shiftwidth, &textwidth, &foldmethod)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>eo :call AppendModeline()<CR>

" fill rest of line with characters
function! FillLine( str )
    " set tw to the desired total length
    let tw = &textwidth
    if tw==0 | let tw = 80 | endif
    " strip trailing spaces first
    .s/[[:space:]]*$//
    " calculate total number of 'str's to insert
    let reps = (tw - col("$")) / len(a:str)
    " insert them, if there's room, removing trailing spaces (though forcing
    " there to be one)
    if reps > 0
        .s/$/\=(' '.repeat(a:str, reps))/
    endif
endfunction

function! FillLineWithMarker()
    call FillLine('-')
    " I have used Char-0x7b in order to not broke vimrc
    .s/.\{4}$/\=" \<Char-0x7b>{{"/
endfunction
map <Leader>f :call FillLine( '-' )<cr>
map <Leader>F :call FillLineWithMarker()<cr>

" }}}

" Section: Commands {{{

function! DiffCurrentFileAgainstAnother(snipoff, replacewith)
    let currentFile = expand('%:p')
    let otherfile = substitute(currentFile, "^" . a:snipoff, a:replacewith, '')
    only
    execute "vertical diffsplit " . otherfile
endfunction
command! -nargs=+ DiffCurrent call DiffCurrentFileAgainstAnother(<f-args>)

function! RedirToYankRegisterF(cmd, ...)
    let cmd = a:cmd . " " . join(a:000, " ")
    redir @*>
    exe cmd
    redir END
endfunction
command! -complete=command -nargs=+ RedirToYankRegister
  \ silent! call RedirToYankRegisterF(<f-args>)

function! FreemindToListF()
    setl filetype=
    silent! :%s/^\(\s*\).*TEXT="\([^"]*\)".*$/\1- \2/
    silent! :g/^\s*</d
    silent! :%s/&quot;/"/g
    silent! :%s/&apos;/\'/g
    silent! g/^-/s/- //
    silent! g/^\w/t.|s/./=/g
    silent! g/^\s*-/normal O
    silent! normal 3GgqG
    silent! %s/^\s\{4}\zs-/o/
    silent! %s/^\s\{12}\zs-/+/
    silent! %s/^\s\{16}\zs-/*/
    silent! %s/^\s\{20}\zs-/#/
    silent! normal gg
endfunction
command! FreemindToList call FreemindToListF()

" }}}

" Section: Auto commands {{{

au BufRead,BufNewFile *.rst,*.md,*.mail,*.unibo,*.tex setl spell spelllang=en_us,it autoindent
au BufNewFile,BufReadPost *.md setl filetype=markdown
au BufNewFile,BufReadPost *.rs setl filetype=rust hidden
au BufNewFile,BufReadPost *.tex setl filetype=tex
au BufNewFile,BufReadPost *.xtext setl filetype=antlr foldmethod=marker
au BufNewFile,BufReadPost *.xtend setl filetype=java
au BufNewFile,BufReadPost *.qa setl filetype=prolog
au BufRead,BufNewFile *.pu,*.plantuml,*.plant setl makeprg=java\ -jar\ ~/misc/plantuml.jar\ -tpng\ -o\ /tmp/\ %
au BufRead,BufNewFile *.g,*.g3,*.g4 setl makeprg=java\ -jar\ /opt/antlr/antlr-3.5.2-complete.jar\ -o\ src/it/unibo/lpemc/implementation/\ %
au BufRead,BufNewFile *.fool setl syntax=fool
"ANTLR  mkdir\ -p\ out&&java\ -jar\ /opt/antlr/antlr-4.4-complete.jar\ -o\ out\ % \ &&javac\ out/%<*.java
au BufEnter *.nse setl filetype=lua tabstop=2 shiftwidth=2
" trick to use fdm syntax+manual ( ty alem0lars )
au BufReadPre * setl foldmethod=syntax
au FileType vim setl foldmethod=marker
au FileType lua setl foldmethod=indent
" do not handle all filetypes
" au BufWinEnter * if &fdm == 'syntax' | setl foldmethod=marker | endif
au FileType haskell let b:ghc_staticoptions = '-Wall'
augroup Python
    au!
    au BufRead,BufEnter,BufNewFile *.py setl textwidth=79  " lines longer than 79 columns will be broken
    au BufRead,BufEnter,BufNewFile *.py setl shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
    au BufRead,BufEnter,BufNewFile *.py setl tabstop=4     " a hard TAB displays as 4 columns
    au BufRead,BufEnter,BufNewFile *.py setl softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
    au BufRead,BufEnter,BufNewFile *.py setl shiftround    " round indent to multiple of 'shiftwidth'
    au BufRead,BufEnter,BufNewFile *.py setl makeprg=pep8\ %
augroup END

augroup Binary
    au!
    au BufReadPre *.bin let &bin=1
    au BufReadPost *.bin if &bin | %!xxd
    au BufReadPost *.bin set filetype=xxd | endif
    au BufWritePre *.bin if &bin | %!xxd -r
    au BufWritePre *.bin endif
    au BufWritePost *.bin if &bin | %!xxd
    au BufWritePost *.bin set nomod | endif
augroup END

"-------------------------------------------------------------------------------
" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
"-------------------------------------------------------------------------------
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" One way to make sure to remove all trailing whitespace in a file is to set an
" autocmd in your .vimrc file. Every time the user issues a :w command, Vim will
" automatically remove all trailing whitespace before saving.
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePre * :retab

" }}}

" Section: Fix constant spelling mistakes {{{
" Go back to last misspelled word and pick first suggestion.
inoremap <F2> <Esc>[s1z=`]a

" Select last misspelled word (typing will edit).
nnoremap <C-k> <Esc>[sve
inoremap <C-k> <Esc>[sve
snoremap <C-k> <Esc>b[sviw
" }}}

" Section: Set up the window colors and size {{{

" Enable 256 colors
set t_Co=256
" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048
set background=dark
let base16colorspace=256
colorscheme jellybeans " base16-default-dark

" Whatever colorscheme ensure to have VertSplit thin
hi VertSplit guibg=bg guifg=bg ctermbg=bg ctermfg=fg
set fillchars+=vert:│

" }}}

" Section: Plugins {{{

" Section: cvim {{{
"let  g:C_UseTool_cmake    = 'yes'
"let  g:C_UseTool_doxygen = 'yes'
" }}}

" Section: YouCompleteMe {{{
" let g:ycm_server_use_vim_stdout = 1
" let g:ycm_server_log_level = 'debug'
" }}}

" Section: UltiSnips {{{

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" }}}

" Section: airline {{{
let g:airline#extensions#bufferline#enabled = 0
let g:airline#extensions#bufferline#overwrite_variables = 0
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline_section_y='Buf:#%n [%b][0x%B]'
" }}}

" Section: ctrlp {{{
 let g:ctrlp_map = '<c-f>'
" }}}

" Section: instant markdown {{{
let g:instant_markdown_autostart = 0
" }}}

" Section: tagbar {{{
nmap <F8> :TagbarToggle<CR>
let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
    \ }
" }}}

" Section: haskell-mode {{{
au BufEnter *.hs compiler ghc
au FileType haskell let b:ghc_staticoptions = '-Wall'
let g:ghc="/usr/bin/ghc"
let g:haddock_browser="/usr/bin/firefox"
" }}}

" Section: zeal-vim {{{
let g:zv_zeal_executable = '/home/jack/repos/zeal/build/bin/zeal'
let g:zv_file_types = {
            \ '(nse|lua)'             : 'lua',
            \ 'py'                    : 'python',
            \ 'rb'                    : 'ruby',
        \ }
" }}}

" Section: syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_lua_checkers = ["luac", "luacheck"]
let g:syntastic_lua_luacheck_args = "--ignore 'robot' 'log' -g -u --no-unused-args"
"let g:syntastic_javascript_checkers = ['jshint']
" }}}

" Section: vim-table-mode {{{
let g:table_mode_corner_corner="+"
let g:table_mode_header_fillchar="="
" }}}

" Section: ack {{{
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
" }}}

" Section: vim-javascript {{{
"let g:javascript_enable_domhtmlcss = 1
" }}}

" Section: vim-jsx {{{
let g:jsx_ext_required = 0
" }}}

" Section: rust.vim {{{
let g:rustfmt_autosave = 1
" }}}

" Section: racer-vim {{{
let g:racer_cmd = "/home/jack/.cargo/bin/racer"
let $RUST_SRC_PATH="/usr/local/src/rust/src/"
" }}}

" }}}

"EOF vim: set ts=4 sw=4 tw=80 :
