#!/bin/bash


if [ "$(whoami)" != "root" ]; then
	echo "Script requires root priviliges"
	exit 1
fi

# Setup dotfiles
if [ ! -d ~/.dotfiles ]; then
  git clone https://github.com/zach-chai/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles && ./install.sh
  cd ~
fi


echo "Finished."
