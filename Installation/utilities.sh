#!/bin/bash

# K9s Configuration

wget https://github.com/derailed/k9s/releases/download/v0.24.15/k9s_Linux_x86_64.tar.gz

tar -xf k9s_Linux_x86_64.tar.gz

sudo mv k9s /usr/bin/

## Verify the Version of k9s

k9s version

# AutoComplete Enable

source <(kubectl completion bash)

echo "source <(kubectl completion bash)" >> ~/.bashrc