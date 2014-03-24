SHELL = /bin/sh

info:
		find . -regex .+~
		find . -name *.swp
del:
		find . -regex .+~ -delete
		find . -name *.swp -delete
install:
		# Dir Colors
		ln -sf shell/dircolors ~/.dircolors
		# BashRC
		ln -sf bashrc ~/.bashrc
		# Vim
		# TODO
		# VimRC
		ln -sf vimrc ~/.vimrc
		# Xinitc
		ln -sf X/xinitrc ~/.xinitrc
		# Xdefaults
		ln -sf X/Xdefaults ~/.Xdefaults
		# GDBinit
		ln -sf Gdbinit/gdbinit ~/.gdbinit
		# ScreenRC
		ln -sf screenrc ~/.screenrc
		# LynxRC
		ln -sf lynxrc ~/.lynxrc
		# PentadactylRC
		ln -sf pentadactylrc ~/.pentadactylrc
		# Xmonad
		ln -sf xmonad/ ~/.xmonad/
		# Makefile
		#ln -sf Makefile ~/Makefile
		# Zsh Profile
		ln -sf zsh/zprofile ~/.zprofile
		# ZshRC
		ln -sf zsh/zshrc ~/.zshrc
		# git-prompt
		ln -sf zsh/gitstatus.py ~/.git-prompt/gitstatus.py
		# TODO redshift,create directory
