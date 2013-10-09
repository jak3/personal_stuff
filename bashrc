#--------------------------------------------------------------------------------
#   This file was maked by cut & paste different bashrc that i found useful. I
#   also add some personal stuff.             
#                                                             
#   Last Changes : Mon 07 Oct 2013 08:45:28 PM CEST
#   Licence      : GPLv3
#   Author       : jake
#--------------------------------------------------------------------------------

# History tricks
#---------------
# set env var HISTIGNORE= OR *better* HISTCONTROL=ignorespace
# with the second env, if we type a command starting with a space
# it wont show up in history
#
# HISTSIZE=0 # don't save history
 
# Trick to use proprely scp
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

## Italian keyboard
setxkbmap -model pc104 -layout it

## My _dirty_ sudo alternative
function sudo(){ su; $*; }

# Export
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
export HISTCONTROL=ignoredups
export ANA=jake@anapnea.net #xn--phnix-ibb.net
export VORTEX=vortex.labs.overthewire.org
export LS_COLORS='rs=0:di=01;34:ln=01;36:hl=44;37:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;93;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;93:*.tgz=01;93:*.arj=01;93:*.taz=01;93:*.lzh=01;93:*.lzma=01;93:*.zip=01;93:*.z=01;93:*.Z=01;93:*.dz=01;93:*.gz=01;93:*.bz2=01;93:*.bz=01;93:*.tbz2=01;93:*.tz=01;93:*.deb=01;93:*.rpm=01;93:*.jar=01;93:*.rar=01;93:*.ace=01;93:*.zoo=01;93:*.cpio=01;93:*.7z=01;93:*.rz=01;93:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:*.pdf=00;31:'


##Alias-------------------------------------------------------------------------
# Set current directory ad default dir to new screen windows
alias cudir='screen -X eval "chdir $PWD"'
alias network='wpa_supplicant -D wext -i wlan1 -c /etc/wpa_supplicant.conf &'
alias network2='dhcpcd wlan1'
alias netrestart='/etc/rc.d/rc.inet1 eth0_restart'
alias grep='grep  --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias webscarab='java -jar /usr/local/WebScarab/webscarab.jar'
alias vimdiff='gvimdiff'
alias vimtutot='gvimtutor'
alias halt='su -c halt'
alias reboot='su -c reboot'
alias shutdown='su -c shutdown'
alias mkdir='mkdir -p'
alias bye='shutdown -h now'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias sudo='su -c'
alias pu='pushd'
alias po='popd'
alias gdb='gdb -q'
alias bc='bc -q'
alias ..='cd ..'
alias cdb='cd ..'
alias cdbb='cd ../../'
alias cdbbb='cd ../../../'
alias c='clear;history -c;dirs -c'
alias ll="ls -l --group-directories-first"
alias ls='ls -hF --color'  # add colors for filetype recognition
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last
alias lm='ls -al |more'    # pipe through 'more'
alias la='ls -a'
alias lr='ls -lR'          # recursive ls
alias las='ls -las'

#-------------------------------------------------------------
# spelling typos - highly personnal and keyboard-dependent :-)
#-------------------------------------------------------------
alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'
alias celar=clear
alias clera=clear
alias cl=clear

#-------------------------------------------------------------
# Shell Prompt
#-------------------------------------------------------------
if [ `/usr/bin/whoami` = 'root' ]
then
    export PS1='\[\033[01;31m\]\u@\h\[\033[00m\]\[\033[01;34m\] \w \[\033[00m\]\$ '
else  
    export PS1='\[\033[1;32m\]\u@\h\[\033[1;34m\] \w \$ \[\033[00m\]'
fi

#-------------------------------------------------------------
# Source global definitions (if any)
#-------------------------------------------------------------

if [ -f /etc/bashrc ]; then
    . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

#-------------------------------------------------------------
# Automatic setting of $DISPLAY (if not set already).
# This works for linux - your mileage may vary. ... 
# The problem is that different types of terminals give
# different answers to 'who am i' (rxvt in particular can be
# troublesome).
# I have not found a 'universal' method yet.
#-------------------------------------------------------------

function get_xserver ()
{
    case $TERM in
        xterm )
            XSERVER=$(whoami | awk '{print $NF}' | tr -d ')''(' ) 
            # Ane-Pieter Wieringa suggests the following alternative:
            # I_AM=$(whoami)
            # SERVER=${I_AM#*(}
            # SERVER=${SERVER%*)}

            XSERVER=${XSERVER%%:*}
            ;;
        aterm | rxvt)
            # Find some code that works here. ...
            ;;
    esac  
}

if [ -z ${DISPLAY:=""} ]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) || \
        ${XSERVER} == "unix" ]]; then 
    DISPLAY=":0.0"          # Display on local host.
    else
    DISPLAY=${XSERVER}:0.0  # Display on remote host.
    fi
fi

export DISPLAY

#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------

ulimit -S -c 0          # Don't want any coredumps.
set -o notify
set -o noclobber
set -o ignoreeof
set -o nounset
set -o vi
#set -o xtrace          # Useful for debuging.

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize ##check the windows size after each command and, if update the values of LINES and COLUMNS.
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob        # Necessary for programmable completion.

# Disable options:
shopt -u mailwarn
unset MAILCHECK         # Don't want my shell to warn me of incoming mail.


export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTTIMEFORMAT="%H:%M > "
export HISTIGNORE="&:bg:fg:ll:h"
export HOSTFILE=$HOME/.hosts    # Put list of remote hosts in ~/.hosts ...



#-------------------------------------------------------------
# Greeting, motd etc...
#-------------------------------------------------------------

# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'              # No Color

# Looks best on a terminal with black background.....
date
if [ -x /usr/games/fortune ]; then
    /usr/games/fortune -s    # Makes our day a bit more fun.... :-)
fi

#-------------------------------------------------------------
# tailoring 'less'
#-------------------------------------------------------------

alias more='less'
#export LESSCHARSET='latin1'
#export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
# Use this if lesspipe.sh exists
#export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
#    :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

#-------------------------------------------------------------
# Make the following commands run in background automatically:
#-------------------------------------------------------------

function firefox() { command firefox "$@" &> /dev/null & }
function xpdf() { command xpdf "$@" &> /dev/null & }

#-------------------------------------------------------------
# File & string-related functions:
#-------------------------------------------------------------

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe()
{ find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

# Find a pattern in a set of files and highlight them:
# (needs a recent version of egrep)
function fstr()
{
    OPTIND=1
    local case=""
    local usage="fstr: find string in files.
    Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
            i) case="-i " ;;
        *) echo "$usage"; return;;
    esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
    echo "$usage"
    return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
    xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more 
}

function lowercase()  # move filenames to lowercase
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
            */*) dirname==${file%/*} ;;
        *) dirname=.;;
    esac
    nf=$(echo $filename | tr A-Z a-z)
    newname="${dirname}/${nf}"
    if [ "$nf" != "$filename" ]; then
        mv "$file" "$newname"
        echo "lowercase: $file --> $newname"
    else
        echo "lowercase: $file not changed."
    fi
    done
}


function swap()  # Swap 2 filenames around, if they exist
{                #(from Uzi's bashrc).
    local TMPFILE=tmp.$$ 

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE 
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function extract()      # Handy Extract Program.
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
        *.tar.gz)    tar xvzf $1     ;;
    *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
         *.tar)       tar xvf $1      ;;
     *.tbz2)      tar xvjf $1     ;;
 *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
         *.Z)         uncompress $1   ;;
     *.7z)        7z x $1         ;;
 *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#-------------------------------------------------------------
# Process/system related functions:
#-------------------------------------------------------------

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

function killps()                 # Kill by process name.
{
     local pid pname sig="-TERM"   # Default signal.
     if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
         echo "Usage: killps [-SIGNAL] pattern"
         return;
     fi
     if [ $# = 2 ]; then sig=$1 ; fi
     for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} ) ; do
         pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
         if ask "Kill process $pid <$pname> with signal $sig?"
         then kill $sig $pid
         fi
     done
}

#-------------------------------------------------------------
# Misc utilities:
#-------------------------------------------------------------

function repeat()       # Repeat n times command.
{
     local i max
     max=$1; shift;
     for ((i=1; i <= max ; i++)); do  # --> C-like syntax
         eval "$@";
     done
}

function ask()          # See 'killps' for example of use.
{
     echo -n "$@" '[y/n] ' ; read ans
     case "$ans" in
         y*|Y*) return 0 ;;
     *) return 1 ;;
 esac
}
