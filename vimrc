"-------------------------------------------------------------------------------
" This .vimrc was made from Derek Wyatt's template. You should visited his site
" if you love vim : derekwyatt.org
" Last changes  : Mon 02 Dec 2013 02:35:25 PM CET
" Author        : jake
" License       : GPLv3
"-------------------------------------------------------------------------------
let PAGER='' "ensure using vim's man and not the system one remapped in bashrc

"-------------------------------------------------------------------------------
" Global Stuff
"-------------------------------------------------------------------------------
" Get pathogen up and running
execute pathogen#infect()
set completeopt=longest,menuone
set wildmode=list:longest,list:full
let g:jedi#popup_on_dot = 0

" Set filetype stuff to on
filetype on
filetype plugin indent on

"backup file only to /tmp 
set backupdir-=.
set backupdir^=/tmp/filebackups

" Tabstops are 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

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
    set shell=ksh.exe
endif

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

" Switch on syntax highlighting.
syntax on

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
set complete=.,w,b,t

" When completing by tag, show the whole tag, not just the function name
set showfulltag

" Set the textwidth to be 80 chars
set textwidth=80

" get rid of the silly characters in separators
set fillchars = ""

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

" System default for mappings is now the "," character
let mapleader = ","

" Trying out the line numbering thing... never liked it, but that doesn't mean
" I shouldn't give it another go :)
"set number
"set relativenumber

" Help Coding ------------------------------------------------------------------

" Let the syntax highlighting for Java files allow cpp keywords
let java_allow_cpp_keywords = 1

" set makeprg
nmap <Leader>ma :set makeprg=gcc\\ -Wall\\ -ggdb3\\ -o\\ %<\\ %<CR>
" set makeprg for test
nmap <Leader>mt :set makeprg=gcc\\ -Wall\\ -ggdb3\\ -o\\ /tmp/%<\\ %<CR>
" set makeprg for test with c99 standard
nmap <Leader>m9 :set makeprg=gcc\\ -Wall\\ -std=c99\\ -ggdb3\\ -o\\ /tmp/%<\\ %<CR>

" tags
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

"-------------------------------------------------------------------------------

" Wipe out all buffers
nmap <silent> <Leader>wa :1,9000bwipeout<cr>

" Toggle paste mode
nmap <silent> <Leader>p :set invpaste<CR>:set paste?<CR>

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

" Alright... let's try this out
imap jj <esc>

" Clear the text using a motion / text object and then move the character to the
" next word
nmap <silent> <Leader>C :set opfunc=ClearText<CR>g@
vmap <silent> <Leader>C :<C-U>call ClearText(visual(), 1)<CR>

"Substitude word under cursor (%s///g)
nnoremap <Leader>s :%s/<C-r><C-w>//g<Left><Left>


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

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048

" Highlight the current line and column
" Don't do this - It makes window redraws painfully slow
set nocursorline
set nocursorcolumn

if has("mac")
  let g:main_font = "Menlo\\ Regular:h11"
  let g:small_font = "Menlo\\ Regular:h2"
else
  let g:main_font = "Monospace\\ 9"
  let g:small_font = "Monospace\\ 2"
endif

"-------------------------------------------------------------------------------
" NERD Tree Plugin Settings
"-------------------------------------------------------------------------------
" Toggle the NERD Tree on an off with F7
nmap <F7> :NERDTreeToggle<CR>

" Close the NERD Tree with Shift-F7
nmap <S-F7> :NERDTreeClose<CR>

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.ncb$', '\.suo$', '\.vcproj\.RIMNET', '\.obj$',
                   \ '\.ilk$', '^BuildLog.htm$', '\.pdb$', '\.idb$',
                   \ '\.embed\.manifest$', '\.embed\.manifest.res$',
                   \ '\.intermediate\.manifest$', '^mt.dep$' ]

"-------------------------------------------------------------------------------
" FSwitch mappings
"-------------------------------------------------------------------------------
nmap <silent> ,of :FSHere<CR>
nmap <silent> ,ol :FSRight<CR>
nmap <silent> ,oL :FSSplitRight<CR>
nmap <silent> ,oh :FSLeft<CR>
nmap <silent> ,oH :FSSplitLeft<CR>
nmap <silent> ,ok :FSAbove<CR>
nmap <silent> ,oK :FSSplitAbove<CR>
nmap <silent> ,oj :FSBelow<CR>
nmap <silent> ,oJ :FSSplitBelow<CR>

"-------------------------------------------------------------------------------
" TwitVim settings
"-------------------------------------------------------------------------------
let twitvim_enable_perl = 1
let twitvim_browser_cmd = 'firefox'
nmap ,tw :FriendsTwitter<cr>
nmap ,tm :UserTwitter<cr>
nmap ,tM :MentionsTwitter<cr>
function! TwitVimMappings()
    nmap <buffer> U :exe ":UnfollowTwitter " . expand("<cword>")<cr>
    nmap <buffer> F :exe ":FollowTwitter " . expand("<cword>")<cr>
    nmap <buffer> 7 :BackTwitter<cr>
    nmap <buffer> 8 :ForwardTwitter<cr>
    nmap <buffer> 1 :PreviousTwitter<cr>
    nmap <buffer> 2 :NextTwitter<cr>
    nmap <buffer> ,sf :SearchTwitter #scala OR #akka<cr>
    nmap <buffer> ,ss :SearchTwitter #scala<cr>
    nmap <buffer> ,sa :SearchTwitter #akka<cr>
    nmap <buffer> ,sv :SearchTwitter #vim<cr>
endfunction
augroup derek_twitvim
    au!
    au FileType twitvim call TwitVimMappings()
augroup END

"-------------------------------------------------------------------------------
" Functions
"-------------------------------------------------------------------------------
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

nmap <silent> ,ii :call IndentToNextBraceInLineAbove()<cr>

nmap <silent> ,mba :call MarkBufferInJumpList(expand('%:p'), 'a')<cr>
nmap <silent> ,mbb :call MarkBufferInJumpList(expand('%:p'), 'b')<cr>
nmap <silent> ,mbc :call MarkBufferInJumpList(expand('%:p'), 'c')<cr>
nmap <silent> ,mbd :call MarkBufferInJumpList(expand('%:p'), 'd')<cr>
nmap <silent> ,mbe :call MarkBufferInJumpList(expand('%:p'), 'e')<cr>
nmap <silent> ,mbf :call MarkBufferInJumpList(expand('%:p'), 'f')<cr>
nmap <silent> ,mbg :call MarkBufferInJumpList(expand('%:p'), 'g')<cr>
nmap <silent> ,jba :call JumpToBufferInJumpList('a')<cr>
nmap <silent> ,jbb :call JumpToBufferInJumpList('b')<cr>
nmap <silent> ,jbc :call JumpToBufferInJumpList('c')<cr>
nmap <silent> ,jbd :call JumpToBufferInJumpList('d')<cr>
nmap <silent> ,jbe :call JumpToBufferInJumpList('e')<cr>
nmap <silent> ,jbf :call JumpToBufferInJumpList('f')<cr>
nmap <silent> ,jbg :call JumpToBufferInJumpList('g')<cr>
nmap <silent> ,ljb :call ListJumpToBuffers()<cr>

function! DiffCurrentFileAgainstAnother(snipoff, replacewith)
    let currentFile = expand('%:p')
    let otherfile = substitute(currentFile, "^" . a:snipoff, a:replacewith, '')
    only
    execute "vertical diffsplit " . otherfile
endfunction

command! -nargs=+ DiffCurrent call DiffCurrentFileAgainstAnother(<f-args>)

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

:nmap ,ha :call HighlightAllOfWord(1)<cr>
:nmap ,hA :call HighlightAllOfWord(0)<cr>

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

:nmap ,ld :call LengthenCWD()<cr>

function! MakeShellcodeFromOpcode()
    silent! %s/ //g
    silent! %s/  //g
    silent! %s/\t//g
    silent! s/\(\(.\)\(.\)\)/\\x\1/g
endfunction

:nmap ,sh :call MakeShellcodeFromOpcode()<cr> 

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

:nmap ,sd :call ShortenCWD()<cr>

function! RedirToYankRegisterF(cmd, ...)
    let cmd = a:cmd . " " . join(a:000, " ")
    redir @*>
    exe cmd
    redir END
endfunction

command! -complete=command -nargs=+ RedirToYankRegister
  \ silent! call RedirToYankRegisterF(<f-args>)

function! ToggleMinimap()
    if exists("s:isMini") && s:isMini == 0
        let s:isMini = 1
    else
        let s:isMini = 0
    end

    if (s:isMini == 0)
        " save current visible lines
        let s:firstLine = line("w0")
        let s:lastLine = line("w$")

        " make font small
        exe "set guifont=" . g:small_font
        " highlight lines which were visible
        let s:lines = ""
        for i in range(s:firstLine, s:lastLine)
            let s:lines = s:lines . "\\%" . i . "l"

            if i < s:lastLine
                let s:lines = s:lines . "\\|"
            endif
        endfor

        exe 'match Visible /' . s:lines . '/'
        hi Visible guibg=lightblue guifg=black term=bold
        nmap <s-j> 10j
        nmap <s-k> 10k
    else
        exe "set guifont=" . g:main_font
        hi clear Visible
        nunmap <s-j>
        nunmap <s-k>
    endif
endfunction

command! ToggleMinimap call ToggleMinimap()
nnoremap <space> :ToggleMinimap<CR>

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf("EOF vim: set ts=%d sw=%d tw=%d :",
        \ &tabstop, &shiftwidth, &textwidth)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>mo :call AppendModeline()<CR>

"-------------------------------------------------------------------------------
" Commands
"-------------------------------------------------------------------------------
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

"-------------------------------------------------------------------------------
" Auto commands
"-------------------------------------------------------------------------------
augroup derek_xsd
    au!
    au BufEnter *.xsd,*.wsdl,*.xml setl tabstop=4 shiftwidth=4
    au BufEnter *.xsd,*.wsdl,*.xml setl formatoptions=crq textwidth=120 colorcolumn=120
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

au BufEnter *.nse setl filetype=lua tabstop=4 shiftwidth=4

"-------------------------------------------------------------------------------
" Fix constant spelling mistakes
"-------------------------------------------------------------------------------
iab teh the
iab Teh The
iab taht that
iab Taht That
iab alos also
iab Alos Also
iab aslo also
iab Aslo Also
iab becuase because
iab Becuase Because
iab bianry binary
iab Bianry Binary
iab bianries binaries
iab Bianries Binaries
iab charcter character
iab Charcter Character
iab charcters characters
iab Charcters Characters
iab exmaple example
iab Exmaple Example
iab exmaples examples
iab Exmaples Examples
iab shoudl should
iab Shoudl Should
iab seperate separate
iab Seperate Separate
iab fone phone
iab Fone Phone

"-------------------------------------------------------------------------------
" Set up the window colors and size
"-------------------------------------------------------------------------------
if has("gui_running")
  exe "set guifont=" . g:main_font
  set background=dark
  colorscheme solarized
  if !exists("g:vimrcloaded")
      winpos 0 0
      if !&diff
          winsize 130 120
      else
          winsize 227 120
      endif
      let g:vimrcloaded = 1
  endif
endif
:nohls						

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

"EOF vim: set ts=4 sw=4 tw=80 :
