#!/bin/bash


if [ "$(whoami)" != "root" ]; then
	echo "Execute with sudo $ sudo ./install.sh"
	exit 1
fi

# Update and install dependencies
apt-get update
apt-get install -y ssh git vim curl wget zsh software-properties-common tmux


# Hub
if ! type "hub" > /dev/null; then
  hub_version="$(wget -qO- https://api.github.com/repos/github/hub/releases/latest | grep tag_name | cut -d'"' -f4 | cut -c 2-)"
  curl -fsSL https://github.com/github/hub/releases/download/v${hub_version}/hub-linux-amd64-${hub_version}.tgz -o hub.tgz \
    && tar -xf hub.tgz \
    && ./hub-linux-amd64-${hub_version}/install \
    && rm -f hub.tgz \
    && rm -rf hub-linux-amd64-${hub_version}
else
	hub_version=$(hub --version | grep hub | cut -d ' ' -f 3)
fi

# Docker
if ! type "docker" > /dev/null; then
  echo "Installing Docker..."
  curl -fsSL https://get.docker.com/ | sh
  usermod -a -G docker $(whoami)
fi

# Docker compose
if ! type "docker-compose" > /dev/null; then
  echo "Installing Docker Compose..."
  compose_version="$(wget -qO- https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d'"' -f4)"
  wget -q https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-`uname -s`-`uname -m`
  mv docker-compose-`uname -s`-`uname -m` /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
else
  compose_version="$(docker-compose -v | cut -d ' ' -f 3 | rev | cut -c 2- | rev)"
fi

# Setup dotfiles
if [ ! -d ~/.dotfiles ]; then
  git clone https://github.com/zach-chai/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles && ./install.sh
  cd ~
fi

echo -e "\nInstalled Versions:"
echo "hub ${hub_version}"
# echo "atom $(atom -v | grep Atom | cut -d ' ' -f 6)"
echo "docker $(docker -v | cut -d ' ' -f 3 | rev | cut -c 2- | rev)"
echo "docker-compose ${compose_version}"

echo "Finished."
