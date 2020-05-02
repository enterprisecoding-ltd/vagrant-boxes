#!/bin/bash

# Parse arguments
while [ $# -gt 0 ]
do
  case "$1" in
    "--masterIp")
      if [ $# -lt 2 ]
      then
        echo "Missing parameter"
	    exit 1
      fi
      MasterIp="$2"
      shift; shift
      ;;
    "--joinScript")
      if [ $# -lt 2 ]
      then
        echo "Missing parameter"
	    exit 1
      fi
      JoinScript="$2"
      shift; shift
      ;;
    *)
      echo "Invalid parameter"
      exit 1
      ;;
  esac
done

echo "Pulling Kubernetes images"
kubeadm config images pull


echo "Initializing Kubernetes"
kubeadm init --apiserver-advertise-address=${MasterIp} --pod-network-cidr=10.244.0.0/16

echo "Preparing kube config for root user"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Preparing kube config for vagrant user"
mkdir -p ~vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf ~vagrant/.kube/config
sudo chown vagrant: ~vagrant/.kube/config


echo "Initializing CNI"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo "Creating join script"
kubeadm token create --print-join-command > "/vagrant/${JoinScript}"

echo "Installing bash completion"
yum install bash-completion -y
echo "source <(kubectl completion bash)" >> ~/.bashrc
source .bashrc

echo "Installing kubens & kubectx"
yum install -y git
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens