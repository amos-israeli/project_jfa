#!/bin/bash
#run me as sudo
apt update
apt install software-properties-common -y
add-apt-repository --yes --update ppa:ansible/ansible
apt install unzip ansible git python3-pip -y
sudo apt-get update && sudo apt-get install python3-dev default-libmysqlclient-dev build-essential -y
ansible-galaxy collection install community.mysql # the community.mysql ansible modol



touch /var/log/ansible.log #create log file for ansible and make ubuntu the owner
chown ubuntu:ubuntu /var/log/ansible.log 





unzip /home/ubuntu/ansible_conf.zip -d ansible_conf
ansible-config init --disabled -t all >/etc/ansible/ansible.cfg
# allow ssh without beeing in the known hosts
sed -i 's/;host_key_checking=True/host_key_checking=False/' /etc/ansible/ansible.cfg 
#mv /home/ubuntu/ansible_key /home/ubuntu/vprofile/exercise1/ansible_key
chown -R ubuntu:ubuntu /home/ubuntu/ansible_conf/
chmod 400 /home/ubuntu/.ssh/ansible_key
rm -rf ansible_conf.zip


#configure git and github ssh key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/git_ansible
chmod 400 /home/ubuntu/.ssh/git_ansible
git-clone@ubuntu:~$ git config --global user.email "ubuntu@amos.com"
git config --global user.name "amos"
git clone https://github.com/t954/project_jfa.git /home/ubuntu/project_jfa
sudo chown -R ubuntu:ubuntu /home/ubuntu/project_jfa/
cd /home/ubuntu/project_jfa/ || { echo "Failure in cd"; exit 1; }
git remote set-url origin git@github.com:t954/project_jfa.git

ln -s project_jfa/ansible_conf/ /home/ubuntu/ansible_conf_link
##install plugins for vim
#indinintation plugin 
git clone https://github.com/Yggdroot/indentLine.git ~/.vim/pack/vendor/start/indentLine
vim -u NONE -c "helptags  ~/.vim/pack/vendor/start/indentLine/doc" -c "q"






# Path to the profile file
PROFILE_FILE="$HOME/.profile"

# Commands to be added to the profile
AGENT_CMD='
# Start SSH agent if not already running
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
fi
'

SSH_KEY_CMD='
# Add SSH key to agent
ssh-add ~/.ssh/git_ansible
'

# Check if the commands are already present
if ! grep -q "Start SSH agent if not already running" "$PROFILE_FILE"; then
  # Append the commands to the profile file
  echo "$AGENT_CMD" >> "$PROFILE_FILE"
  echo "$SSH_KEY_CMD" >> "$PROFILE_FILE"
  echo "SSH agent setup added to $PROFILE_FILE."
else
  echo "SSH agent setup already present in $PROFILE_FILE."
fi
