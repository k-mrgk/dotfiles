#!/bin/bash -ux

THIS_DIR=$(cd $(dirname $0); pwd)

if [ $(uname) = Linux ]; then
	cd $THIS_DIR
	git submodule init
	git submodule update
fi

echo "start setup..."
cd $HOME

for file in .config .gitconfig
do
	[ ! -e $file ] && ln -s $THIS_DIR/$file .
done

if [ $(uname) = Darwin ]; then 
    xcode-select --install
	defaults write com.apple.screencapture name "ss"
	mkdir $HOME/Pictures/ScreenShots/
	defaults write com.apple.screencapture location ~/Pictures/ScreenShots/
    defaults write com.apple.finder AppleShowAllFiles TRUE
    killall Finder
	echo "installing Homebrew ..."
	which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
	echo "installing Linuxbrew ..."
	which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
	export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

cd $THIS_DIR

echo "run brew doctor ..."
which brew >/dev/null 2>&1 && brew doctor

echo "run brew update ..."
brew update

echo "run brew upgrade ..."
brew upgrade
brew bundle
brew cleanup

# install rbenv pyenv nodenv
anyenv install rbenv
anyenv install pyenv
anyenv install nodenv
anyenv install goenv
exec $SHELL -l

# install rust
echo "install Rust ..."
curl https://sh.rustup.rs -sSf | sh

# install iterm2 shell integration
echo "install iterm2 shell integration ..."
if [ $(uname) = Darwin ]; then
	curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
fi


# change default shell
echo "set fish shell ..."
echo /usr/local/bin/fish >> /etc/shells
chsh -s /usr/local/bin/fish


# Create a .ssh directory and add public key
ssh_dir=$HOME/.ssh
auth_file=$HOME/.ssh/authorized_keys

if [ ! -e $ssh_dir ];
then
    mkdir $ssh_dir
    chmod 700 $ssh_dir
fi

if [ ! -e $auth_file ];
then
    touch $auth_file
    chmod 600 $auth_file
fi
