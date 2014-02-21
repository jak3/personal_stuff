info:
		find . -regex .+~
		find . -name *.swp
del:
		find . -regex .+~ -delete
		find . -name *.swp -delete
install:
		# Dir Colors
		ln -s shell/dircolors ~/.dircolors
		# BashRC
		ln -s bashrc ~/.bashrc
		# Vim
		ln -s vim/ ~/.vim
		# VimRC
		ln -s vimrc ~/.vimrc
		# Xinitc
		ln -s X/xinitrc ~/.xinitrc
		# Xdefaults
		ln -s X/Xdefaults ~/.Xdefaults
		# GDBinit
		ln -s Gdbinit/gdbinit ~/.gdbinit
		# ScreenRC
		ln -s screenrc ~/.screenrc
		# LynxRC
		ln -s lynxrc ~/.lynxrc
		# PentadactylRC
		ln -s pentadactylrc ~/.pentadactylrc
		# Pentadactyl
		ln -s X/pentadactyl ~/.pentadactyl
		# Xmonad
		ln -s xmonad/ ~/.xmonad/
		# XmonadConky
		ln -s xmonad/conky_dzen ~/.xmonad/.conky_dzen
		# Makefile
		ln -s Makefile ~/Makefile
		# Zsh Profile
		ln -s zsh/zprofile ~/.zprofile
		# ZshRC
		ln -s zsh/zshrc ~/.zshrc
		# git-prompt
		ln -s zsh/gitstatus.py ~/.git-prompt/gitstatus.py
