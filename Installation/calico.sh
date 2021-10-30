#!/bin/bash

#Dowload and Install Calicoctl

curl -o calicoctl -O -L  "https://github.com/projectcalico/calicoctl/releases/download/v3.20.2/calicoctl"

sudo mv calicoctl /usr/bin/

sudo chmod +x /usr/bin/calicoctl

# Install the Tigera Calico operator and custom resource definitions.

kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml

echo "Wait for 1 Min, Installation is in Progress"

sleep 30

kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml

# Confirm that all of the pods are running with the following command.

echo "Wait for 1 Min, Resource Confirguration is being done"

sleep 30

kubectl get pods -n calico-system

# Display all the nodes.

kubectl get nodes -o wide

# Check weather Clicoctl is working fine or not.

calicoctl get nodes

# Verifying the Pods in tigera-operator

kubectl get pods -n tigera-operator

# Verifying the Pods in calico-system

kubectl get pods -n calico-system

# Verifying the Pods in calico-apiserver

kubectl get pods -n calico-apiserver