# dev-env-script
Script to setup basic environment stuff

## Steps:
1. Run install script `curl -sSL https://raw.githubusercontent.com/zach-chai/dev-env-script/master/install.sh | sudo sh`
2. Set shell to ZSH `chsh -s $(which zsh)`
3. Add user to docker group `sudo usermod -aG docker $USER`
4. Logout and back log back in

Shell should now be switched to ZSH and `docker version` should connect to server.
