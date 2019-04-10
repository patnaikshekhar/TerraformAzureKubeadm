sleep 20
# These steps need to be performed on all nodes
sudo apt update -q
# Install Docker
echo "Installing Docker"
sudo apt install docker.io -y
sudo systemctl enable docker
echo "Finished Installing Docker"
# Get the gpg keys for Kubeadm
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update -q
# Install Kubeadm
echo "Installing Kubeadm"
sudo apt install kubeadm -y
echo "Finished Installing Kubeadm"