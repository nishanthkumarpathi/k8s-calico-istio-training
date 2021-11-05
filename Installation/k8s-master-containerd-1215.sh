#!/bin/bash

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


#Update the apt source list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] http://apt.kubernetes.io/ kubernetes-xenial main"

# Install all utitilies

# Below Command is used for Latest version of Kubeadm and Kubectl
# sudo apt -y install vim git curl wget kubelet kubeadm kubectl

# For this Demo, we are Installing 21 Version, because of Calico Cloud Integration

sudo apt install -y kubeadm=1.21.5-00 kubelet=1.21.5-00 kubectl=1.21.5-00

sudo apt-mark hold kubelet kubeadm kubectl

# Initialize master node
lsmod | grep br_netfilter
sudo systemctl enable kubelet

# Pull container images
sudo kubeadm config images pull


sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --cri-socket=unix:///run/containerd/containerd.sock --config kubeadm-config.yaml

echo "Please Wait for 1 Min and Dont Cancel the Operation. Script will continue executing after 1 min break automatically"

sleep 60

#Create .kube file if it does not exists
mkdir -p $HOME/.kube

#Move Kubernetes config file if it exists
if [ -f $HOME/.kube/config ]; then
    mv $HOME/.kube/config $HOME/.kube/config.back
fi

sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sleep 30

# List of Installed Softwares
echo "**** List of Installed Softwares ****"

kubectl version --client

kubeadm version


# Here is the final Cluster Information
kubectl cluster-info


echo "Done."

echo "Installation of Kubernetes Master has completed"
echo "*************************************************"
echo "Dont Close the Terminal, however observe the last few lines of output"

kubectl get nodes -o wide

kubeadm config print join-defaults

echo "You are supposed to copy the join command and run on the worker nodes."

