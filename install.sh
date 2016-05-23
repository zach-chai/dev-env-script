#!/bin/bash


if [ "$(whoami)" != "root" ]; then
	echo "Script requires root priviliges"
	exit 1
fi

# Update and install dependencies
apt-get update
apt-get install -y ssh git vim curl wget zsh software-properties-common


hub_version="$(wget -qO- https://api.github.com/repos/github/hub/releases/latest | grep tag_name | cut -d'"' -f4 | cut -c 2-)"

# Install hub
curl -sSL https://github.com/github/hub/releases/download/v${hub_version}/hub-linux-amd64-${hub_version}.tgz -o hub.tgz \
  && tar -xf hub.tgz \
  && ./hub-linux-amd64-${hub_version}/install \
  && rm -f hub.tgz \
  && rm -rf hub-linux-amd64-${hub_version}


# Install atom
add-apt-repository -y ppa:webupd8team/atom
apt-get update
apt-get install -y atom
apm install language-docker
apm install file-icons
apm install symbols-tree-view
apm install auto-detect-indentation
apm install highlight-selected


# Setup dotfiles
if [ ! -d ~/.dotfiles ]; then
  git clone https://github.com/zach-chai/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles && ./install.sh
  cd ~
fi


echo "Finished."
