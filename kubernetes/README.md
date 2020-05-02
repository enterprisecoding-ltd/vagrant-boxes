# Vagrantfile to setup a Kubernetes Cluster

This Vagrantfile will provision a Kubernetes cluster with one master and _n_ worker nodes (2 by default).

## Prerequisites
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://vagrantup.com/)
3. Install [Vagrant VirtualBox Guest Additions](https://github.com/dotless-de/vagrant-vbguest) `vagrant plugin install vagrant-vbguest`

## Quickstart
Run following commands to start cluster
```shell
git clone https://github.com/enterprisecoding-ltd/vagrant-boxes`
cd kubernetes
vagrant up
```

then ssh into master node using `vagrant ssh master`

## Optional vagrant plugins
It is advised to install following Vagrant plugins:

- [vagrant-env](https://github.com/gosuri/vagrant-env): loads environment variables from .env files : `vagrant plugin install vagrant-env`
- [vagrant-hosts](https://github.com/oscar-stack/vagrant-hosts): maintains /etc/hosts for the guest VMs : `vagrant plugin install vagrant-hosts`

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