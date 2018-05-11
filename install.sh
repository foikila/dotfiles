#/bin/sh

if [ -z $1 ]; then
    printf "Usage: ./install.sh [desktop-enviroment]\n"
    exit
fi 
CP="cp -i"

# DE stuff

cd $1

./de-install.sh

cd -

# prog

sudo apt install kdiff3 clipit git 

# Configs

$CP tmux.conf ~/.tmux.conf
$CP bashrc ~/.bashrc
$CP gitconfig ~/.gitconfig

$CP vimrc ~/.vimrc
$CP vim/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim 
