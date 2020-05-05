#!/bin/bash

yum install -y epel-release

# Installing Redis
echo "Installing Redis"
yum install redis -y

sed -i "s/bind 127.0.0.1/bind 0.0.0.0/g" /etc/redis.conf

# Start redis service
echo "Starting redis service"
systemctl start redis.service
systemctl enable redis