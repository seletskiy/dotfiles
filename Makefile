install:
	ln -fs `readlink -f bashrc`    $(HOME)/.bashrc
	ln -fs `readlink -f muttrc`    $(HOME)/.muttrc
	ln -fs `readlink -f gitconfig` $(HOME)/.gitconfig
	ln -fs `readlink -f dircolors.256dark` $(HOME)/.dircolors
	ln -fs `readlink -f vimrc` $(HOME)/.vimrc
	ln -fs `readlink -f vim` $(HOME)/.vim
	ln -fs `readlink -f irssi` $(HOME)/.irssi
	ln -fs `readlink -f terminfo` $(HOME)/.terminfo
	ln -fs `readlink -f xresources` $(HOME)/.XResources
	mkdir -p $(HOME)/.config/
	ln -fs `readlink -f awesome` $(HOME)/.config/awesome/

