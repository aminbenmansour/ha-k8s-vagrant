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

# Host operating sysem detection
module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end

  def OS.jruby?
    RUBY_ENGINE == "jruby"
  end
end

# Determine host adpater for bridging in BRIDGE mode
def get_bridge_adapter()
  if OS.windows?
    return %x{powershell -Command "Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Get-NetAdapter | Select-Object -ExpandProperty InterfaceDescription"}.chomp
  elsif OS.linux?
    return %x{ip route | grep default | awk '{ print $5 }'}.chomp
  elsif OS.mac?
    return %x{mac/mac-bridge.sh}.chomp
  end
end

# Helper method to get the machine ID of a node.
# This will only be present if the node has been
# created in VirtualBox.
def get_machine_id(vm_name)
  machine_id_filepath = ".vagrant/machines/#{vm_name}/virtualbox/id"
  if not File.exist? machine_id_filepath
    return nil
  else
    return File.read(machine_id_filepath)
  end
end

# Helper method to determine whether all nodes are up
def all_nodes_up()
  if get_machine_id("controlplane").nil?
    return false
  end

  (1..NUM_WORKER_NODES).each do |i|
    if get_machine_id("node0#{i}").nil?
      return false
    end
  end
  return true
end

# Sets up hosts file and DNS
def setup_dns(node)
  # Set up /etc/hosts
  node.vm.provision "setup-hosts", :type => "shell", :path => "vagrant/setup-hosts.sh" do |s|
    s.args = [IP_NW, BUILD_MODE, NUM_WORKER_NODES, MASTER_IP_START, NODE_IP_START]
  end
  # Set up DNS resolution
  node.vm.provision "setup-dns", type: "shell", :path => "ubuntu/update-dns.sh"
end

# Runs provisioning steps that are required by masters and workers
def provision_kubernetes_node(node)
  # Set up DNS
  setup_dns node
  # Set up ssh
  node.vm.provision "setup-ssh", :type => "shell", :path => "ubuntu/ssh.sh"
end
