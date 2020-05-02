#!/bin/bash

systemctl stop firewalld
systemctl disable firewalld

modprobe overlay
modprobe br_netfilter

cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

echo overlay >> /etc/modules-load.d/overlay.conf
echo br_netfilter >> /etc/modules-load.d/br_netfilter.conf

# Update repos
yum update -y

# Disable swap
swapoff -a
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

# Set SELinux mode to permissive
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/sysconfig/selinux

# Install Docker prereqs
yum install -y yum-utils device-mapper-persistent-data lvm2

# Setup docker repo
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
yum install -y docker-ce

mkdir /etc/docker

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Add vagrant user to docker group
usermod -a -G docker vagrant

# Enable & start Docker daemon
systemctl daemon-reload
systemctl enable docker
systemctl start docker

# Setup Kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

# Install Kubelet
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Enable & start Kubelet daemon
systemctl enable --now kubelet
systemctl daemon-reload
systemctl restart kubelet