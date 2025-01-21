#!/bin/bash
#run me as sudo
apt update
apt install software-properties-common -y
add-apt-repository --yes --update ppa:ansible/ansible
apt install unzip ansible git python3-pip -y
sudo apt-get update && sudo apt-get install python3-dev default-libmysqlclient-dev build-essential -y

ansible-galaxy collection install community.mysql


unzip /home/ubuntu/ansible_conf.zip -d ansible_conf
ansible-config init --disabled -t all >/etc/ansible/ansible.cfg
sed -i 's/;host_key_checking=True/host_key_checking=False/' /etc/ansible/ansible.cfg
#mv /home/ubuntu/ansible_key /home/ubuntu/vprofile/exercise1/ansible_key
#chmod 400 /home/ubuntu/vprofile/exercise1/ansible_key
chown -R ubuntu:ubuntu /home/ubuntu/ansible_conf/
chmod 400 /home/ubuntu/.ssh/ansible_key
rm -rf ansible_conf.zip
