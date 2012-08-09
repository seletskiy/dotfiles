.PHONY: install

install:
	ln -fs `readlink -f bashrc` $(HOME)/.bashrc
