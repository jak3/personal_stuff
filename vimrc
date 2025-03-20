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
  runtime! ftplugin/man.vim      " man page in a Vim window
  set rtp+=~/repos/fzf
endif

" weird: https://robertbasic.com/blog/force-python-version-in-vim/
if has('python3')
endif

source $STUFF/vim/vimrc/plugins.vim
source $STUFF/vim/vimrc/glob.vim

"EOF vim: set ts=4 sw=4 tw=80 :
