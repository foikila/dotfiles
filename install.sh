#/bin/sh

if [ -z $1 ]; then
    printf "Usage: ./install.sh [desktop-enviroment]\n"
    exit
fi 
CP="cp -i"

# DE stuff

./$1/menu-install.sh

# Configs

$CP tmux.conf ~/.tmux.conf
$CP bashrc ~/.bashrc
$CP gitconfig ~/.gitconfig

$CP vimrc ~/.vimrc
$CP vim/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim 
