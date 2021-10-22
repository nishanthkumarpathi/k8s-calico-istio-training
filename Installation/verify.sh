#!/bin/bash

# Install a Simple Nginx Pod

kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml

# You should see the Output

kubectl get pods -o wide

echo "***************************************************"

echo "If you see the Pod IP in the Network of Calico ( 192.168.0.0/16), i.e all our setup is working fine."