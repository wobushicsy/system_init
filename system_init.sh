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

# vim
sudo apt update \
	&& sudo apt install -y vim

# git
sudo apt install -y git \
	&& git config --global user.name wobushicsy \
	&& git config --global user.email wobushicsy@gmail.com

# essentials
sudo apt install -y build-essential python3 golang-go cmake curl wget

# zsh
sudo apt install -y zsh \
	&& sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

