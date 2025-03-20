" Section: vim-plug {{{

call plug#begin()

" Theme
Plug 'bling/vim-airline'
Plug 'chriskempson/base16-vim'
Plug 'crusoexia/vim-dracula'
Plug 'mhartington/oceanic-next'
Plug 'nanotech/jellybeans.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline-themes'

" IDE
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'

" Generic
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-git'
Plug 'tpope/vim-abolish'
Plug 'vim-scripts/VisIncr'
Plug 'mileszs/ack.vim'
Plug 'junegunn/vim-peekaboo'
"Plug 'xolox/vim-easytags'
Plug 'ludovicchabant/vim-gutentags'
Plug 'vim-syntastic/syntastic'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'yaegassy/coc-pylsp', {'do': 'yarn install --frozen-lockfile'}

" Plug 'w0rp/ale'
Plug 'rking/ag.vim'
"Plug 'KabbAmine/zeavim.vim' " Offline Docs
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Languages
Plug 'eagletmt/neco-ghc'
Plug 'lukerandall/haskellmode-vim'
Plug 'tpope/vim-markdown'
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
Plug 'xolox/vim-lua-ftplugin'
Plug 'xolox/vim-misc' " dependence of vim-lua-ftplugin and easytags
Plug 'Rykka/riv.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug '2072/PHP-Indenting-for-VIm'
Plug 'mattn/emmet-vim'
Plug 'mzlogin/vim-smali'
Plug 'masukomi/vim-markdown-folding'
Plug 'Exafunction/codeium.vim'

" install https://github.com/jszakmeister/markdown2ctags.git
" into ~/.vim/plugged/tagbar-ext.vim/bin/markdown2ctags.py
Plug 'tenfyzhong/tagbar-ext.vim'

" Typescript
Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'

" Testing
Plug 'dhruvasagar/vim-table-mode'
"Plug 'lervag/vimtex'
"Plug 'vim-scripts/c.vim'

" Personal
Plug 'jak3/potion'

call plug#end()

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

" Trigger configuration. Do not use <tab> if you use completion plugins
let g:UltiSnipsExpandTrigger="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" }}}

" Section: airline {{{
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '》'
let g:airline_right_sep = '«'
let g:airline_right_sep = '《'
let g:airline_symbols.crypt = 'crypt'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = 'maxln'
let g:airline_symbols.maxlinenr = 'maxln'
let g:airline_symbols.branch = 'branch'
let g:airline_symbols.paste = 'paste'
let g:airline_symbols.spell = 'spell'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

"let g:airline_powerline_fonts = 1
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

" Section: tpope/vim-markdown {{{
let g:markdown_fenced_languages = ['java', 'bash', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'html', 'xml']
" }}}

" Section: tagbar {{{
nmap <F8> :TagbarToggle<CR>
let g:tagbar_sort = 0
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

" Section: syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
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
if executable('rg')
  let g:ackprg = 'rg --vimgrep'
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

" Section: neco-ghc {{{
" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" }}}

" Section: fzf {{{
let g:fzf_command_prefix = 'Fzf'
let g:fzf_buffers_jump = 1      " [Buffers] to existing split

function! s:build_location_list(lines) abort
    call setloclist(0, map(copy(a:lines), '{ "filename": v:val }'))
    lopen
endfunction

function! s:build_quickfix_list(lines) abort
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
endfunction

" An action can be a reference to a function that processes selected lines
let g:fzf_action = {
            \ 'ctrl-l': function('s:build_quickfix_list'),
            \ 'ctrl-r': function('s:build_location_list'),
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit'}
" \ 'ctrl-o': '<S-tab>',
" \ 'ctrl-i': 'insert_match',

" function! s:insert_match(lines) abort
"   <c-r>=echo('a:lines')<cr>
" endfunction

nnoremap <silent> <leader>e :<C-u>FZF<CR>
nnoremap <leader><c-f> :FzfFiles .<cr>
nnoremap <leader>F :FzfFiles /<cr>
nnoremap <leader>fb :FzfBuffers<cr>
nnoremap <leader>b :FzfBuffers<cr>
nnoremap <leader>fw :FzfWindows<cr>
nnoremap <leader>ft :FzfTags<cr>
nnoremap <leader>f<c-t> :FzfBTags<cr>
nnoremap <leader>fc :FzfCommit<cr>
nnoremap <leader>f<c-c> :FzfBCommit<cr>
nnoremap <leader>fg :FzfGFiles?<cr>
nnoremap <leader>f<c-g> :FzfGFiles<cr>
nnoremap <leader>fl :FzfLines<cr>
nnoremap <leader>f<c-l> :FzfBLines<cr>
nnoremap <leader>f; :FzfHistory:<cr>
nnoremap <leader>f/ :FzfHistory/<cr>
nnoremap <leader>fh :FzfHistory<cr>
nnoremap <leader>fm :FzfHelptags<cr>
nnoremap <leader>fs <esc>:FzfSnippets<cr>
nnoremap <leader>fr <esc>:Rg<cr>
inoremap <c-x><c-s> <c-o>:FzfSnippets<cr>


" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

let g:fzf_tags_command = 'ctags -R'
" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'rounded' } }

let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline --bind "ctrl-o:toggle+up,ctrl-space:toggle-preview"'
let $FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/**'"
"-g '!{node_modules,.git}'

" Customize fzf colors to match your color scheme
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
  \   'bg':      ['bg', 'Normal'],
  \   'gutter':  ['bg', 'Normal'],
  \   'hl':      ['fg', 'Comment'],
  \   'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \   'bg+':     ['bg', 'Visual', 'CursorColumn'],
  \   'hl+':     ['fg', 'Statement'],
  \   'info':    ['fg', 'PreProc'],
  \   'border':  ['fg', 'vertsplit'],
  \   'prompt':  ['fg', 'Conditional'],
  \   'pointer': ['fg', 'Exception'],
  \   'marker':  ['fg', 'Keyword'],
  \   'spinner': ['fg', 'Label'],
  \   'header':  ['fg', 'Comment'] }
    " \ 'border':  ['fg', 'Conditional'],

"Get Files
command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

" Get text in files with Rg
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   "rg --column --line-number --no-heading --color=always --smart-case --glob '!.git/**' ".shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0)

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen) abort
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Git grep
command! -bang -nargs=* GGrep
    \ call fzf#vim#grep(
    \   'git grep --line-number '.shellescape(<q-args>), 0,
    \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
" }}}

" Section: ag {{{
nnoremap <leader>ag :<C-u>Ag<space>
" }}}

" Section: coc {{{
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "<tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>fx <Plug>(coc-format-selected)
nmap <leader>fx <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" }}}

" Section: ALE {{{
nmap <silent> <leader>ta :ALEToggle<CR>
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_open_list = 1
let g:ale_lint_on_text_changed = "never"

let g:ale_max_buffer_history_size = 32
let g:ale_maximum_file_size = 67108864 " 64 MiB

let g:ale_fix_on_save=1

let g:ale_fixers = {
\   'typescript': ['tslint', 'prettier', 'eslint'],
\   'json': ['prettier'],
\}

let g:ale_pattern_options = {'[.min.js|.java]$': {'ale_enabled': 0}}
" }}}

" Section: lsp {{{
let g:lsp_diagnostics_enabled = 0         " disable diagnostics support
" }}}

" Section: lsp-settings {{{
let g:lsp_settings = {
\   'pyls-all': {
\     'workspace_config': {
\       'pyls': {
\         'configurationSources': ['flake8']
\       }
\     }
\   },
\}
" }}}
" Section: codeium {{{
let g:codeium_disable_bindings = 0
" }}}

" }}}


