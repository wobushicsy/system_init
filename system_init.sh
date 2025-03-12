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
proxyon
sudo apt install -y zsh \
	&& sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
proxyoff

# docker
curl -fsSL get.docker.com -o get-docker.sh && sudo sh get-docker.sh --mirror Aliyun \
  && sudo systemctl enable docker && sudo systemctl start docker \
  && sudo groupadd -f docker && sudo usermod -aG docker $USER
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
MSG="WSL config changed, remember to restart WSL in powershell by run
wsl --terminate <Distro>"
sudo cp ./configs/wsl.conf /etc \
  && echo $MSG

