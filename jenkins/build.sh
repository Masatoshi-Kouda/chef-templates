#!/bin/bash
####################
# FUNCTION
####################
ssh_config () {
    local port=$1
    local ipaddr=$2
    cat << EOF
Host container
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

####################
# MAIN
####################
bundle install --path vendor/bundle

cd $WORKSPACE/docker
RETVAL=0
sudo docker images | grep -q centos6/sshd || RETVAL=$?
if [ "$RETVAL" -ne 0 ]; then
    sudo rm -f ./id_rsa*
    sudo rm -f ./authorized_keys
    sudo -u jenkins ssh-keygen -t rsa -C '' -f ./id_rsa -N ''
    sudo cp -f id_rsa.pub authorized_keys 
    sudo docker build -t centos6/sshd .
fi

sudo docker run -d -P --name test_sshd centos6/sshd
sleep 3
port=$(sudo docker inspect --format='{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostPort}}' test_sshd)
ipaddr=$(sudo docker inspect --format '{{ .NetworkSettings.Gateway }}' test_sshd)
ssh_config $port $ipaddr > $WORKSPACE/docker/ssh_config

cd $WORKSPACE/chef
bundle exec knife solo bootstrap container -F $WORKSPACE/docker/ssh_config -r role[monitor]

sudo docker stop test_sshd
sudo docker rm test_sshd
