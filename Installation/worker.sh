#!/bin/bash

# Update all installed packages.
sudo apt update -y

# if you get an error similar to
# '[ERROR Swap]: running with swap on is not supported. Please disable swap', disable swap:
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

# Install some utils
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Configure Sysctl 

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# >>> Install Containerd Runtime

# Configure persistent loading of modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF


# Load at runtime
sudo modprobe overlay
sudo modprobe br_netfilter

# Ensure sysctl params are set
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload configs
sudo sysctl --system

sudo modprobe overlay
sudo modprobe br_netfilter


# Install required packages
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates


# Add Docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"


# Install containerd
sudo apt update
sudo apt install -y containerd.io


# Configure containerd and start service
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
#sudo containerd config default  /etc/containerd/config.toml

# restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

# >>> Containerd Configuration Done

#Update the apt source list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] http://apt.kubernetes.io/ kubernetes-xenial main"

# Install all utitilies
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Initialize master node
lsmod | grep br_netfilter
sudo systemctl enable kubelet



# List of Installed Softwares
echo "**** List of Installed Softwares ****"

kubectl version --client



echo "Done."

echo "Installation of Kubernetes Workder has completed"
echo "*************************************************"
echo "Dont Close the Terminal"

echo "You are supposed to copy the join command from master server and run on the worker nodes."