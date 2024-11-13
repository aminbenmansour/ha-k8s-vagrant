#!/bin/bash
set -euo pipefail

PRIMARY_IP=$1
POD_CIDR=10.244.0.0/16
SERVICE_CIDR=10.96.0.0/16


# initialize the controlplane node
kubeadm init --pod-network-cidr $POD_CIDR --service-cidr $SERVICE_CIDR --apiserver-advertise-address $PRIMARY_IP

# deploy pod network to the cluster
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# protect script against write access
chmod 551 ./worker-node.sh
