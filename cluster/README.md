# Joining the cluster

The command given during the cluster initialization might not work later as a result of the token is subject to change (need to learn more about kubernetes).

To join the cluster, print to join command on the control-plane

```bash
kubeadm token create --print-join-command

```

The output of this command should be later executed on the worker node.