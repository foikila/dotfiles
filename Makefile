FILES = .vimrc .gitconfig 
DIRS = .vim .oh-my-zsh
PPA = ppa:webupd8team/sublime-text-2  
PROGRAMS = git vim sublime-text 

install:
		sudo add-apt-repository $(PPA)
		sudo apt-get update
		sudo apt-get install $(PROGRAMS)	
		install $(FILES) ~
		rsync -av .vim ~
		rsync -av .oh-my-zsh ~

.bashrc:
		echo "source .bashrc_my" >> ~/.bashrc
.zshrc:
		echo "source .zshrc >> ~/.zshrc
