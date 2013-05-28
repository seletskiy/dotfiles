common: gitconfig dircolors vim terminfo xorg i3 mutt zsh

gitconfig:
	ln -fsT `readlink -f gitconfig` $(HOME)/.gitconfig

dircolors:
	ln -fsT `readlink -f dircolors_dark` $(HOME)/.dircolors

vim:
	ln -fsT `readlink -f vimrc` $(HOME)/.vimrc
	ln -fsT `readlink -f vim` $(HOME)/.vim

terminfo:
	ln -fsT `readlink -f terminfo` $(HOME)/.terminfo

xorg: xinit xresources

xresources:
	ln -fsT `readlink -f xresources` $(HOME)/.XResources

xinit:
	ln -fsT `readlink -f xinit` $(HOME)/.xinit

config:
	mkdir -p $(HOME)/.config/

i3: config
	ln -fsT `readlink -f i3` $(HOME)/.i3

mutt:
	ln -fsT `readlink -f muttrc` $(HOME)/.muttrc
	ln -fsT `readlink -f mutt` $(HOME)/.mutt
	echo -n >> $(HOME)/.mutt/aliases
	./_template.py mutt/accounts.template > $(HOME)/.mutt/accounts

zsh:
	ln -fsT `readlink -f zshrc` $(HOME)/.zshrc
	ln -fsT `readlink -f zsh` $(HOME)/.zsh
	./_template.py zsh/prompt.sh.template > $(HOME)/.zsh/prompt.sh
	./_template.py zsh/background.sh.template > $(HOME)/.zsh/background.sh
