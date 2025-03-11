#! /usr/bin/sh

# proxy
proxyon () {
  host_ip=$(cat /etc/resolv.conf | grep -oP "(?<=nameserver\ ).*")
  export http_proxy="http://$host_ip:7890"
  export https_proxy="http://$host_ip:7890"
}

proxyoff () {
  export http_proxy=""
  export https_proxy=""
}

sudo apt update

# utils
sudo apt install -y man curl wget zip

# vim
sudo apt install -y vim

# git
sudo apt install -y git

# programming essentials
sudo apt install -y build-essential cmake python3 pip

# golang
wget -O - https://go.dev/dl/go1.22.6.linux-amd64.tar.gz | sudo tar -zx -C /usr/local

# zsh
sudo apt install -y zsh \
	&& sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# link config files
DOTFILES_DIR="$(pwd)/dotfiles"
TARGET_DIR="$HOME"
for file in "$DOTFILES_DIR"/.*; do
  filename=$(basename "$file")
  target_file="$TARGET_DIR/$filename"
  ln -fs $file $target_file
done

