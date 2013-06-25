# Configuration that should present anywhere.
common: check-target git terminal vim xorg i3 mutt zsh bin fonts

check-target:
	# This Makefile should be invoked either with:
	#   make laptop
	#   make home
	#   make work
	[ "$(TARGET)" ] || exit 1

# Laptop specific target
# Here and next TARGET is a special variable used in recipes to choose
# right config to use.
laptop: TARGET=laptop
laptop: common
	# Laptop configuration set has been installed.

# Conf groups listed next.
git: $(HOME)/.gitconfig

vim: $(HOME)/.vimrc $(HOME)/.vim\
	$(HOME)/.vim/bundle/vim-powerline/autoload/Powerline/Colorschemes/solarized.vim

terminal: $(HOME)/.terminfo $(HOME)/.dircolors

xorg: $(HOME)/.xinitrc $(HOME)/.Xresources $(HOME)/.Xresources.dark\
	$(HOME)/.Xresources.light /etc/systemd/system/x11.service\
	/etc/X11/xorg.conf

mutt: $(HOME)/.muttrc $(HOME)/.mutt $(HOME)/.mutt/aliases $(HOME)/.mutt/accounts

zsh: $(HOME)/.zshrc $(HOME)/.zsh $(HOME)/.zsh/prompt.sh

i3: $(HOME)/.i3 $(HOME)/.i3/i3status.conf

bin: $(HOME)/bin

fonts: $(HOME)/.fonts
	fc-cache -f

# Shorthand functions.
link = $(shell ln -fvsT `readlink -f $(1)` $(2) >&2)
sulink = $(shell sudo ln -fvsT `readlink -f $(1)` $(2) >&2)
template = $(shell ./_template.py $(1).template > $(2))

# Exact configuration files listed next.
$(HOME)/.i3/i3status.conf: i3/i3status.conf.*
	$(call link,i3/i3status.conf.$(TARGET),$(HOME)/.i3/i3status.conf) /etc/systemd/system/x11.service

$(HOME)/.vim/autoload/Powerline/Colorschemes/solarized.vim:
	patch -d$(HOME)/.vim/bundle/vim-powerline/ -Np1 < $(HOME)/.vim/vim-powerline-solarized.patch || exit 0

$(HOME)/.gitconfig:
	$(call link,gitconfig,$@)

$(HOME)/.dircolors:
	$(call link,dircolors_$(BACKGROUND),$@)

$(HOME)/.vimrc:
	$(call link,vimrc,$@)

$(HOME)/.vim:
	$(call link,vim,$@)

$(HOME)/.terminfo:
	$(call link,terminfo,$@)

$(HOME)/.Xresources:
	$(call link,xresources,$@)

$(HOME)/.Xresources.dark:
	$(call link,xresources.dark,$@)

$(HOME)/.Xresources.light:
	$(call link,xresources.light,$@)

$(HOME)/.xinitrc:
	$(call template,xinitrc,$@)

/etc/systemd/system/x11.service: systemd/x11.service
	$(call sulink,systemd/x11.service,$@)
	sudo systemctl daemon-reload
	sudo systemctl enable x11.service

/etc/X11/xorg.conf: xorg.conf.*
	$(call sulink,xorg.conf.$(TARGET),$@)

$(HOME)/.config:
	mkdir -p $@

$(HOME)/.i3:
	$(call link,i3,$@)

$(HOME)/.muttrc:
	$(call link,muttrc,$@)

$(HOME)/.mutt:
	$(call link,mutt,$@)

$(HOME)/.mutt/aliases:
	echo -n >> $(HOME)/.mutt/aliases

$(HOME)/.mutt/accounts:
	$(call template,mutt/accounts,$@)

$(HOME)/.zshrc:
	$(call link,zshrc,$@)

$(HOME)/.zsh:
	$(call link,zsh,$@)

$(HOME)/.zsh/prompt.sh:
	$(call template,zsh/prompt.sh,$@)

$(HOME)/bin:
	$(call link,bin,$@)

$(HOME)/.fonts:
	$(call link,fonts,$@)
