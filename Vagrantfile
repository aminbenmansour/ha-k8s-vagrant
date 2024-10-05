# Set the build mode
# "BRIDGE" - Places VMs on your local network so cluster can be accessed from browser.
#            You must have enough spare IPs on your network for the cluster nodes.
# "NAT"    - Places VMs in a private virtual network. Cluster cannot be accessed
#            without setting up a port forwarding rule for every NodePort exposed.
#            Use this mode if for some reason BRIDGE doesn't work for you.
BUILD_MODE = "BRIDGE"

# Define the number of worker nodes
# If this number is changed, remember to update setup-hosts.sh script with the new hosts IP details in /etc/hosts of each VM.
NUM_WORKER_NODES = 2

# Network parameters for NAT mode
IP_NW = "192.168.56"
MASTER_IP_START = 11
NODE_IP_START = 20