info:
		find . -regex .+~
		find . -name *.swp
del:
		find . -regex .+~ -delete
		find . -name *.swp -delete

# Software needed: zsh, vim, git, rxvt-unicode, xmonad, xmobar, redshift, feh,
# xsel, xpdf, xscreensaver
# Slackware x86_64 multilib: follow alien's multilib README
install:
		# Dir Colors
		ln -sf ${STUFF}/shell/dircolors ~/.dircolors
		# BashRC
		ln -sf ${STUFF}/bashrc ~/.bashrc
		# Vim
		ln -sf ${STUFF}/vim ~/.vim
		# VimRC
		ln -sf ${STUFF}/vimrc ~/.vimrc
		# Xinitc
		ln -sf ${STUFF}/X/xinitrc ~/.xinitrc
		# Xdefaults
		ln -sf ${STUFF}/X/Xdefaults ~/.Xdefaults
		# ScreenRC
		ln -sf ${STUFF}/screenrc ~/.screenrc
		# LynxRC
		ln -sf ${STUFF}/lynxrc ~/.lynxrc
		# PentadactylRC
		ln -sf ${STUFF}/pentadactylrc ~/.pentadactylrc
		# PentadactylDIR
		ln -sf ${STUFF}/pentadactyl ~/.pentadactyl
		# git-prompt
		mkdir -p ~/.git-prompt
		ln -sf ${STUFF}/zsh/gitstatus.py ~/.git-prompt/gitstatus.py
		# xpdf
		ln -sf ${STUFF}/xpdfrc ~/.xpdfrc
