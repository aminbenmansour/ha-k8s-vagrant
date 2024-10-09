#!/bin/bash

$PRIMARY_IP=$1
POD_CIDR=10.244.0.0/16
SERVICE_CIDR=10.96.0.0/16


# initialize the controlplane node
JOIN_COMMAND=$(kubeadm init --pod-network-cidr $POD_CIDR --service-cidr $SERVICE_CIDR --apiserver-advertise-address $PRIMARY_IP | tail -n 2)


# deploy pod network to the cluster
kubectl --kubeconfig /etc/kubernetes/admin.conf \
    apply -f "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml"


# generate the join command for worker nodes
cat <<EOF > worker-node.sh
#!/bin/bash

$JOIN_COMMAND
EOF


# protect script against write access
chmod 551 ./worker-node.sh
