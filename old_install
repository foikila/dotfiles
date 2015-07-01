#!/bin/bash

files="zshrc vimrc gitconfig bashrc"
dir=~/dotfiles
backup=~/.dotfiles_old
prog="zsh cowsay"

mkdir -p $backup

sudo apt-get install -y $prog

cowsay I\'m starting with backup old files

for file in $files; 
do 
	# mv ~/.$file $backup/$file
	# ln -s $dir/$file ~/.$file
	rsync $dir/$file ~/.$file
done

cowsay Done!

cowsay Time to install oh-my-zsh

#############################
#  OH-MY-ZSH install script #
############################# 

set -e 

if [ ! -n "$ZSH" ]; then
  ZSH=~/.oh-my-zsh
fi

if [ -d "$ZSH" ]; then
  cowsay You already have Oh My Zsh installed. 0m You\'ll need to remove $ZSH if you want to install
	exit
fi

hash git >/dev/null 2>&1 && env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH || {
  cowsay git not installed
  exit
}

touch ~/.zshrc

cowsay Copying your current PATH and adding it to the end of ~/.zshrc for you 

sed -i -e "/export PATH=/ c\\
export PATH=\"$PATH\"
" ~/.zshrc

if [ "$SHELL" != "$(which zsh)" ]; then
    cowsay Time to change your default shell to zsh!
    chsh -s `which zsh`
fi

echo ""'         __                                     __   '""
echo ""'  ____  / /_     ____ ___  __  __   ____  _____/ /_  '""
echo ""' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '""
echo ""'/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '""
echo ""'\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '""
echo ""'                        /____/                       ....is now installed!'""

env zsh
. ~/.zshrci

rsync zshrc ../.zshrc  

source 	~/.zshrc

cowsay Yey! I\'m done!

