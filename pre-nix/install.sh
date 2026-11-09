#/bin/sh

if [ -z $1 ]; then
    printf "Usage: ./install.sh [desktop-enviroment]\n"
    exit
fi 

if [ ! -d $1 ]; then
    printf "'$1' isn't supported\n"
    exit
fi

CP="cp -i"

function install {
    echo "sudo apt install $@"
    sudo apt install $@
}


# prog

install kdiff3 clipit git 


# DE stuff

install $1 

echo "cd $1"
cd $1

./de-install.sh

cd -

# Configs

$CP tmux.conf ~/.tmux.conf
$CP bashrc ~/.bashrc
$CP gitconfig ~/.gitconfig

$CP vimrc ~/.vimrc
$CP vim/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim


