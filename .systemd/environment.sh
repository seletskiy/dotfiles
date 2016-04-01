export DOTFILES_PROFILE=$(cat ~/.dotfiles/profile)
export PATH=$(find -L $HOME/bin -type d -printf "%p:")$HOME/.go/bin/:$HOME/.deadfiles/bin:$PATH
export GOPATH=~/.go/
export EDITOR=vim
export DMENU_PATH=~/bin/.dmenu/
