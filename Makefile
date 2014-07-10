SHELL = /bin/sh

info:
		find . -regex .+~
		find . -name *.swp
del:
		find . -regex .+~ -delete
		find . -name *.swp -delete
install:
		# Dir Colors
		ln -sf personal_stuff/shell/dircolors ~/.dircolors
		# BashRC
		ln -sf personal_stuff/bashrc ~/.bashrc
		# Vim
		# TODO
		# VimRC
		ln -sf personal_stuff/vimrc ~/.vimrc
		# Xinitc
		ln -sf personal_stuff/X/xinitrc ~/.xinitrc
		# Xdefaults
		ln -sf personal_stuff/X/Xdefaults ~/.Xdefaults
		# GDBinit
		ln -sf personal_stuff/Gdbinit/gdbinit ~/.gdbinit
		# ScreenRC
		ln -sf personal_stuff/screenrc ~/.screenrc
		# LynxRC
		ln -sf personal_stuff/lynxrc ~/.lynxrc
		# PentadactylRC
		ln -sf personal_stuff/pentadactylrc ~/.pentadactylrc
		# Xmonad
		ln -sf personal_stuff/xmonad/ ~/.xmonad/
		# Makefile
		#ln -sf Makefile ~/Makefile
		# Zsh Profile
		ln -sf personal_stuff/zsh/zprofile ~/.zprofile
		# ZshRC
		ln -sf personal_stuff/zsh/zshrc ~/.zshrc
		# git-prompt
		ln -sf personal_stuff/zsh/gitstatus.py ~/.git-prompt/gitstatus.py
		# TODO redshift,create directory
