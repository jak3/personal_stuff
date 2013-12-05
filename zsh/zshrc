# {{{ Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
zstyle ':completion::complete:*' use-cache 1

setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE
setopt NUMERIC_GLOB_SORT
setopt autocd extendedglob notify correct

bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'

autoload -Uz compinit
compinit
# }}} End of lines added by compinstall

# My Own custom modification
# SSH completion {{{
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
# }}}

# FPATH {{{
#fpath=($STUFF/zsh/zsh-completions/src $fpath)
# }}}

# {{{ Custom key binding
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

emacs-backward-word() {
  local WORDCHARS="${WORDCHARS:s@/@}"
  zle backward-word
}
#zle -N emacs-backward-word
#bindkey ';5D' emacs-backward-word
#bindkey ';5C' emacs-forward-word
# }}}

# SOURCES {{{

STUFF=$HOME/linux

source $STUFF/shell/environment
source $STUFF/shell/functions
source $STUFF/shell/aliases

#source $STUFF/shell/asciiart

export __GIT_PROMPT_DIR=$STUFF/zsh/git-prompt

source $STUFF/zsh/history-substring-search.zsh
source $STUFF/zsh/git-prompt/zshprompt.sh
source $STUFF/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# }}}

# PROMT {{{

autoload -U promptinit
promptinit
prompt walters
setopt PROMPT_SUBST
#PROMPT='%(!.%F{red}.%F{yellow})%1~ %f%(!.%F{red}.%F{blue})%#%f '
#PROMPT='$(git_super_status) %f%(!.%F{red}.%F{yellow})∞%f '
PROMPT='$(git_super_status) %f%(!.%F{red}.%F{yellow})>%f '

# CD HOOK {{{
chpwd_functions=(save_dir)
# }}}

case $TERM in 
xterm*)
  precmd () {
    print -Pn "\e]0;%n@%m: %~\a"
  }
  ;;
esac
#}}}

