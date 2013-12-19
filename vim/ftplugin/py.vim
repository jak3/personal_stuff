let g:pymode_rope = 0
" Use l to toggle display of whitespace
nmap l :set list!
" And set some nice chars to do it with
set listchars=tab:»\ ,eol:¬

" automatically change window's cwd to file's dir
set autochdir

" I'm prefer spaces to tabs
set tabstop=4
set shiftwidth=4
set expandtab

let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_checker_args='--ignore=E501,E225'

" more subtle popup colors
if has ('gui_running')
    highlight Pmenu guibg=#cccccc gui=bold
endif
