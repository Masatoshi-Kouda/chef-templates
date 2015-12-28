#!/bin/bash
####################
# FUNCTION
####################
ssh_config () {
    local port=$1
    local ipaddr=$2
    cat << EOF
Host app
  HostName ${ipaddr}
  User docker
  Port ${port}
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile "$WORKSPACE/docker/id_rsa"
  IdentitiesOnly yes
  LogLevel FATAL
EOF
}

node_json () {
    cat << EOF
{
  "run_list": [
    "recipe[base]"
  ]
}
EOF
}

####################
# MAIN
####################
bundle install --path vendor/bundle

cd $WORKSPACE/docker
sudo docker images | grep -q centos/sshd
if [ $? -ne 0 ]; then
    sudo rm -f ./id_rsa*
    sudo -u jenkins ssh-keygen -t rsa -C '' -f ./id_rsa -N ''
    sudo docker build -t centos/sshd .
fi

sudo docker run -d -P --name test_sshd centos/sshd
port=$(sudo docker inspect --format='{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostPort}}' test_sshd)
ipaddr=$(sudo docker inspect --format '{{ .NetworkSettings.Gateway }}' test_sshd)
ssh_config $port $ipaddr > ~/.ssh/ssh_config

node_json > $WORKSPACE/chef/nodes/app.json

sleep 3
cd $WORKSPACE/chef
bundle exec knife solo bootstrap app -F ~/.ssh/ssh_config

sudo docker stop test_sshd
sudo docker rm test_sshd
