#!/bin/bash

curl -L https://istio.io/downloadIstio | sh -

cd istio-1.11.4

sudo cp -r bin/istioctl /usr/bin/

sudo chmod +x  /usr/bin/istioctl

# Verify the Istioctl version

istioctl version

# Validate Cluster meets Istio Install Requirements by running the PreCheck

istioctl x precheck
