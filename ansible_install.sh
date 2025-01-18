#!/bin/bash
#add the real ip adresess
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y



mkdir -p /home/ubuntu/vprofile/exercise1/
echo """
all:
  hosts:
    web01:
      ansible_host: 172.31.3.175
    web02:
      ansible_host: 172.31.11.175
    db01:
      ansible_host: 172.31.3.180

  children:
    webservers:
      hosts:
        web01:
        web02:
    dbservers:
      hosts:
        db01:
    dc_oregon:
      children:
        webservers:
        dbservers:
      vars:
        ansible_ssh_private_key_file: ansible_key
        ansible_user: ec2-user


"""> /home/ubuntu/vprofile/exercise1/inventory


ansible-config init --disabled -t all > /etc/ansible/ansible.cfg
sed -i 's/;host_key_checking=True/host_key_checking=False/' /etc/ansible/ansible.cfg

mv /home/ubuntu/ansible_key /home/ubuntu/vprofile/exercise1/ansible_key
chmod 400 /home/ubuntu/vprofile/exercise1/ansible_key
chown -R ubuntu:ubuntu /home/ubuntu/vprofile/


