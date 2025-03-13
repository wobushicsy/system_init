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

# prepare
set -x
proxyoff
sudo apt-get update > /dev/null

# utils
sudo apt-get install -y man curl wget zip > /dev/null

# vim
sudo apt-get install -y vim > /dev/null

# git
sudo apt-get install -y git > /dev/null

# programming essentials
sudo apt-get install -y build-essential cmake python3 pip > /dev/null

# golang
wget -O - https://go.dev/dl/go1.22.6.linux-amd64.tar.gz | sudo tar -zx -C /usr/local

# zsh
proxyon
sudo apt-get install -y zsh > /dev/null \
	&& CHSH=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" > /dev/null
proxyoff

# docker
proxyon
curl -fsSL get.docker.com -o /tmp/get-docker.sh && sudo sh /tmp/get-docker.sh --mirror Aliyun \
  && sudo systemctl enable docker && sudo systemctl start docker \
  && sudo groupadd -f docker && sudo usermod -aG docker $USER
proxyoff
sudo cp ./configs/daemon.json /etc/docker \
  && sudo systemctl daemon-reload && sudo systemctl restart docker

# link config files
DOTFILES_DIR="$(pwd)/dotfiles"
TARGET_DIR="$HOME"
for file in "$DOTFILES_DIR"/.*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    target_file="$TARGET_DIR/$filename"
    ln -fs $file $target_file
  fi
done

# wsl
MSG="WSL config changed, remember to restart WSL in powershell by run\nwsl --terminate <Distro>"
sudo cp ./configs/wsl.conf /etc \
  && echo -e $MSG >&2

