#!/bin/bash


if [ "$(whoami)" != "root" ]; then
	echo "Script requires root priviliges"
	exit 1
fi

# Update and install dependencies
apt-get update
apt-get install -y ssh git vim curl wget zsh software-properties-common

# Hub
hub_version="$(wget -qO- https://api.github.com/repos/github/hub/releases/latest | grep tag_name | cut -d'"' -f4 | cut -c 2-)"

curl -sSL https://github.com/github/hub/releases/download/v${hub_version}/hub-linux-amd64-${hub_version}.tgz -o hub.tgz \
  && tar -xf hub.tgz \
  && ./hub-linux-amd64-${hub_version}/install \
  && rm -f hub.tgz \
  && rm -rf hub-linux-amd64-${hub_version}


# Atom
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

# Docker
if ! type "docker" > /dev/null; then
  echo "Installing Docker..."
  wget -qO- https://get.docker.com/ | sh
  usermod -a -G docker $(whoami)
fi

# Docker compose
if ! type "docker-compose" > /dev/null; then
	echo "Installing Docker Compose..."
  LATEST="$(wget -qO- https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d'"' -f4)"
  wget -q https://github.com/docker/compose/releases/download/${LATEST}/docker-compose-`uname -s`-`uname -m`
  mv docker-compose-`uname -s`-`uname -m` /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi


echo "Finished."
