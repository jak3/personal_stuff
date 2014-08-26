SHELL = /bin/sh

info:
		find . -regex .+~
		find . -name *.swp
del:
		find . -regex .+~ -delete
		find . -name *.swp -delete
install:
		# Dir Colors
		ln -sf $STUFF/shell/dircolors ~/.dircolors
		# BashRC
		ln -sf $STUFF/bashrc ~/.bashrc
		# Vim
		ln -sf $STUFF/vim ~/.vim
		# VimRC
		ln -sf $STUFF/vimrc ~/.vimrc
		# Xinitc
		ln -sf $STUFF/X/xinitrc ~/.xinitrc
		# Xdefaults
		ln -sf $STUFF/X/Xdefaults ~/.Xdefaults
		# GDBinit
		ln -sf $STUFF/gdb/Gdbinit/gdbinit ~/.gdbinit
		# ScreenRC
		ln -sf $STUFF/screenrc ~/.screenrc
		# LynxRC
		ln -sf $STUFF/lynxrc ~/.lynxrc
		# PentadactylRC
		ln -sf $STUFF/pentadactylrc ~/.pentadactylrc
		# Xmonad
		ln -sf $STUFF/xmonad/ ~/.xmonad/
		# Zsh Profile
		ln -sf $STUFF/zsh/zprofile ~/.zprofile
		# ZshRC
		ln -sf $STUFF/zsh/zshrc ~/.zshrc
		# git-prompt
		mkdir -p ~/.git-prompt
		ln -sf $STUFF/zsh/gitstatus.py ~/.git-prompt/gitstatus.py
		# TODO redshift,create directory
