#!/bin/bash

files="vimrc gitconfig zshrc bashrc"
dir=~/dotfiles
backup=~/dotfiles_old

cd $dir

mkdir -p $backup

for file in $files; do 
	mv ~/.$file ~/$backup
	ls -s $dir/$file ~/.$file
done


echo "Done!"
cd ~

