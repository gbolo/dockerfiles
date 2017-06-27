#!/bin/sh
## bash may not be installed, dont do any bashy stuff...
set -e

BROADCAST(){
  local MESSAGE=$1
  echo
  echo "==================================="
  echo " > ${MESSAGE}"
  echo "==================================="
  echo
}

if [ "${GENERATE_NEW_KEYS}" = "true" ]; then
  BROADCAST "GENERATING NEW SSH CLIENT KEY"
  echo -e  'y\n' | ssh-keygen -t rsa -f /home/jenkins/.ssh/id_rsa -N ''
  ssh-keygen -y -t rsa -f /home/jenkins/.ssh/id_rsa > /home/jenkins/.ssh/id_rsa.pub
  chown -R jenkins:jenkins /home/jenkins/.ssh
  cat /home/jenkins/.ssh/id_rsa.pub
  BROADCAST "GENERATING NEW SSH HOST KEYS"
  echo -e  'y\n' | ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N ''
  echo -e  'y\n' | ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''
  echo -e  'y\n' | ssh-keygen -q -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N ''
  echo
fi

if [ "${CHANGE_JENKINS_PASSWD}" = "true" ]; then
  BROADCAST "CHANGING JENKINS USER PASSWORD"
  adduser -m -p "${JENKINS_PASSWD_HASH}" jenkins
fi

if [ "${JENKINS_AUTHORIZED_KEY}" != "none" ]; then
  BROADCAST "ADDING AUTHORIZED KEY"
  echo "${JENKINS_AUTHORIZED_KEY}" | tee /home/jenkins/.ssh/authorized_keys
  chown jenkins:jenkins /home/jenkins/.ssh/authorized_keys
  chmod 400 /home/jenkins/.ssh/authorized_keys
fi

BROADCAST "STARTING SSHD"
echo "ssh logs not viewable without syslog..."
/usr/sbin/sshd -D
