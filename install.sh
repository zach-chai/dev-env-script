#!/bin/bash


if [ "$(whoami)" != "root" ]; then
	echo "Script requires root priviliges"
	exit 1
fi

# Update and install dependencies
apt-get update
apt-get install -y ssh git vim curl wget zsh software-properties-common


# Setup dotfiles
if [ ! -d ~/.dotfiles ]; then
  git clone https://github.com/zach-chai/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles && ./install.sh
  cd ~
fi


echo "Finished."
