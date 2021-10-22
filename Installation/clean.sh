#!/bin/bash

# Clean the Pod Created in the Verification Process.

kubectl delete -f https://k8s.io/examples/pods/simple-pod.yaml

kubectl get pods -o wide

echo "***************************************************"