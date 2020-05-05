# Vagrantfile to setup a Kubernetes Cluster
  
This Vagrantfile will provision a Kubernetes cluster with one master and _n_ worker nodes (2 by default).
  
## Prerequisites

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://vagrantup.com/)
3. Install [Vagrant VirtualBox Guest Additions](https://github.com/dotless-de/vagrant-vbguest) `vagrant plugin install vagrant-vbguest`

  
## Quickstart

Run following commands to start cluster

```shell
git clone https://github.com/enterprisecoding-ltd/vagrant-boxes
cd vagrant-boxes/kubernetes
vagrant up
```
  
then ssh into master node using `vagrant ssh master`
  
## Optional vagrant plugins

It is advised to install following Vagrant plugins:
  
-  [vagrant-env](https://github.com/gosuri/vagrant-env): loads environment variables from .env files : `vagrant plugin install vagrant-env`
-  [vagrant-hosts](https://github.com/oscar-stack/vagrant-hosts): maintains /etc/hosts for the guest VMs : `vagrant plugin install vagrant-hosts`
  
## Remove


```shell
vagrant halt
vagrant destroy
```

or remove specific node

```shell
vagrant halt worker2
vagrant destroy worker2
```

## Parameters

Following parameters are avaliable to configure Kubernetes installation;
   
| Parameter | Default Value | Details
|--|--|--|
| WORKER_NODES | 2 | Number of worker nodes |
| ACCESS_FROM_HOST | false | To access your cluster from the host, set the following variable to true |
| MASTER_IP | 192.168.10.100 | Master Node IP adress |
| WORKER_MEMORY | 4096 | Memory for the worker VMs |
| WORKER_CPU | 1 | Number of Worker Node CPU  |
| MASTER_MEMORY | 2048 | Memory for the master VM |
| MASTER_CPU | 2 | Number of Master Node CPU |
| INSTALL_HELM | false | To install Helm, set the following variable to true |
| INSTALL_NGINX | false | To install Nginx, set the following variable to true |
| INSTALL_OLM | false | To install Operator Lifecycle Manager, set the following variable to true |
| INSTALL_OPERATORS |  | Comma seperated list of operators to install. Use install yaml name without .yaml extension. i.e.: For grafana operator with url https://operatorhub.io/install/grafana-operator.yaml use 'grafana-operator' |
  
  
If you set **ACCESS_FROM_HOST**, you can add cluster to your host context using following command;

```shell
KUBECONFIG=~/.kube/config:kubeconfig kubectl config view --merge --flatten > ~/.kube/config
```

also you can use following command to switch new context;

```shell
kubectl config use-context kubernetes-admin@kubernetes
```