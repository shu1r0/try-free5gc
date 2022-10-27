#!/bin/bash

# go
sudo apt -y update
# sudo apt -y install golang
wget https://go.dev/dl/go1.19.2.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.19.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo "export PATH=$PATH:/usr/local/go/bin" >> /home/vagrant/.bashrc


# Control-plane Supporting Packages
# sudo apt -y update
sudo apt -y install wget git

sudo apt -y install gnupg
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb

## ref: https://askubuntu.com/questions/1403619/mongodb-install-fails-on-ubuntu-22-04-depends-on-libssl1-1-but-it-is-not-insta
curl -fsSL https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt update -y
sudo apt install -y mongodb-org
sudo systemctl enable mongod
sudo systemctl start mongod



# User-plane Supporting Packages
# sudo apt -y update
sudo apt -y install git gcc g++ cmake autoconf libtool pkg-config libmnl-dev libyaml-dev

# Linux Host Network Settings
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE  # sudo iptables -t nat -A POSTROUTING -o <dn_interface> -j MASQUERADE
sudo iptables -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1400
sudo systemctl stop ufw


# install free5gc
cd /home/vagrant
git clone --recursive -b v3.2.1 -j `nproc` https://github.com/free5gc/free5gc.git
cd free5gc
cd /home/vagrant/free5gc
make


# install upf
cd /home/vagrant
git clone https://github.com/free5gc/gtp5g.git
cd gtp5g
make
sudo make install
cd -

# install webconsole
sudo apt -y remove cmdtest
sudo apt -y remove yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get update -y
sudo apt-get install -y nodejs yarn

# install network tools
# sudo apt -y install tshark

# ssh
sed -i "/PasswordAuthentication/c\PasswordAuthentication yes" /etc/ssh/sshd_config
systemctl restart sshd
