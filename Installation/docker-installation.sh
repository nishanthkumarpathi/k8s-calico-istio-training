#!/bin/bash

# Update all installed packages.
sudo apt update -y

# if you get an error similar to
# '[ERROR Swap]: running with swap on is not supported. Please disable swap', disable swap:
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

# install some utils
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg gnupg2 lsb-release curl wget 

#Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg


echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Configure containerd and start service
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml


# restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd


#Enable docker service
sudo systemctl start docker
sudo systemctl enable docker

sudo groupadd docker

sudo usermod -aG docker $USER

echo "Next Follow the Instructions as per the labguide or ask instructor"