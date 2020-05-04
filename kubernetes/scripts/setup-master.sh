#!/bin/bash

InstallOLM=false
InstallHelm=false
InstallNginx=false

# Parse arguments
while [ $# -gt 0 ]
do
  case "$1" in
    "--installOLM")
      InstallOLM=true
      shift
      ;;
    "--installHelm")
      InstallHelm=true
      shift
      ;;
    "--installNginx")
      InstallNginx=true
      shift
      ;;    
    "--installOperators")
      if [ $# -lt 2 ]
      then
        echo "Missing parameter"
	    exit 1
      fi
      IFS=',' read -r -a InstallOperators <<< "$2"
      shift; shift
      ;;
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


if [ "$InstallHelm" = true ] || [ "$InstallNginx" = true ]; then
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
  /usr/local/bin/helm repo add stable https://kubernetes-charts.storage.googleapis.com
fi

if [ "$InstallNginx" = true ]; then
  kubectl create ns ingress-nginx
  /usr/local/bin/helm install nginx-ingress stable/nginx-ingress --namespace ingress-nginx \
    --set controller.kind=DaemonSet \
    --set controller.metrics.enabled=true \
    --set controller.service.type=NodePort\
    --set controller.hostNetwork=true \
    --set controller.daemonset.useHostPort=true
fi

if [ "$InstallOLM" = true ] || [ ${#InstallOperators[@]} ]; then
  echo "Installing Operator Lifecycle Manager"
  OLM_RELEASE=$(curl -s https://api.github.com/repos/operator-framework/operator-lifecycle-manager/releases/latest | grep tag_name | cut -d '"' -f 4)
  kubectl apply -f https://github.com/operator-framework/operator-lifecycle-manager/releases/download/${OLM_RELEASE}/crds.yaml
  kubectl apply -f https://github.com/operator-framework/operator-lifecycle-manager/releases/download/${OLM_RELEASE}/olm.yaml
fi

for operator in "${InstallOperators[@]}"
do
    echo "Installing Operator : $operator"
    kubectl create -f https://operatorhub.io/install/$operator.yaml
done