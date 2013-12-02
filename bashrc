#--------------------------------------------------------------------------------
#   This file was maked by cut & paste different bashrc that i found useful. I
#   also add some personal stuff.             
#                                                             
#   Last Changes : Mon 02 Dec 2013 12:44:15 PM CET
#   Licence      : GPLv3
#   Author       : jake
#--------------------------------------------------------------------------------
# Trick to use proprely scp
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

STUFF="$HOME/personal_stuff"

source $STUFF/shell/functions
source $STUFF/shell/aliases 

source $STUFF/scripts/git-completion.bash
source $STUFF/scripts/git-prompt.sh

## Italian keyboard
setxkbmap -model pc104 -layout it

# Export
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
export HISTCONTROL=ignoredups
export ANA=jake@anapnea.net #xn--phnix-ibb.net
export VORTEX=vortex.labs.overthewire.org

#-------------------------------------------------------------
# Shell Prompt
#-------------------------------------------------------------
if [ `/usr/bin/whoami` = 'root' ]
then
    export PS1='\[\033[01;31m\]\u\[\033[00m\]\[\033[01;34m\] \w \[\033[00m\]\$ '
else  
    export PS1='\[\033[1;32m\]\u\[\033[1;34m\] \w \$\[\033[00m\]$(__git_ps1 " (%s)")'
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

#alias more='less'
#export LESSCHARSET='latin1'
#export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
# Use this if lesspipe.sh exists
#export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \

# History tricks
#---------------
# set env var HISTIGNORE= OR *better* HISTCONTROL=ignorespace
# with the second env, if we type a command starting with a space
# it wont show up in history
# HISTSIZE=0 # don't save history
