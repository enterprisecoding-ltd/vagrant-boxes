# Vagrantfile to install Redis

This Vagrantfile will provision a Redis vm.

## Quickstart

Run following commands to start cluster

```shell
git clone https://github.com/enterprisecoding-ltd/vagrant-boxes
cd vagrant-boxes/redis
vagrant up
```
  
then ssh into vm using `vagrant ssh`

## Optional vagrant plugins

It is advised to install following Vagrant plugin:
  
-  [vagrant-env](https://github.com/gosuri/vagrant-env): loads environment variables from .env files : `vagrant plugin install vagrant-env`

## Remove

```shell
vagrant halt
vagrant destroy
```
## Parameters

Following parameters are avaliable to configure Kubernetes installation;
   
| Parameter | Default Value | Details
|--|--|--|
| HOSTNAME |  | Hostname for vm |
| ACCESS_FROM_HOST | false | To access your cluster from the host, set the following variable to true |
| IP |  | VM IP adress |
| MEMORY | 2014 | Memory for VM |
| CPU | 1 | Number of VM CPU  |
  
In order to change any parameter install [vagrant-env](https://github.com/gosuri/vagrant-env) plugin, copy **.env** file with name **.env.local**. Find the parameter you are looking for. uncomment by removing # infront. Finally, set its value.
