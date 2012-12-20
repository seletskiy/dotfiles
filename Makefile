install:
	ln -fsT `readlink -f bashrc`    $(HOME)/.bashrc
	ln -fsT `readlink -f muttrc`    $(HOME)/.muttrc
	ln -fsT `readlink -f gitconfig` $(HOME)/.gitconfig
	ln -fsT `readlink -f dircolors.256dark` $(HOME)/.dircolors
	ln -fsT `readlink -f vimrc` $(HOME)/.vimrc
	ln -fsT `readlink -f vim` $(HOME)/.vim
	ln -fsT `readlink -f irssi` $(HOME)/.irssi
	ln -fsT `readlink -f terminfo` $(HOME)/.terminfo
	ln -fsT `readlink -f xresources` $(HOME)/.XResources
	mkdir -p $(HOME)/.config/
	ln -fsT `readlink -f awesome` $(HOME)/.config/awesome

