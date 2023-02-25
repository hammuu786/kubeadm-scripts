#!/bin/bash
#
# Setup for Control Plane (Master) servers

set -euxo pipefail

MASTER_IP=$(nslookup $(hostname -f) | awk '/^Address: / { print $2 }')
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

sudo kubeadm config images pull

echo "Preflight Check Passed: Downloaded All Required Images"

sudo kubeadm init --apiserver-advertise-address=$MASTER_IP --apiserver-cert-extra-sans=$MASTER_IP --pod-network-cidr=$POD_CIDR --node-name "$NODENAME" --ignore-preflight-errors Swap

mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Install Claico Network Plugin Network 

kubectl apply -f kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml


##on Executed server i mean opertaionl server you need to perform these commands
## copy the .kube folder in opertaionl file
#  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#  sudo chmod +x kubectl
#  sudo mv kubectl /usr/local/bin
# Add kubectl aliases to .bashrc
#echo "alias ku='kubectl'" >> ~/.bashrc
#echo "alias kd='kubectl get deploy'" >> ~/.bashrc
#echo "alias kn='kubectl get nodes'" >> ~/.bashrc
#echo "alias kdp='kubectl describe pod'" >> ~/.bashrc
#echo "alias kdn='kubectl describe no'" >> ~/.bashrc
#echo "alias ks='kubectl get svc'" >> ~/.bashrc

# Reload .bashrc to activate aliases
# source ~/.bashrc
#