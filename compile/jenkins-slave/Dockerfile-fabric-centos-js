# This Image can be used as a jenkins docker slave

FROM gbolo/compile:fabric-centos7

# ENVIRONMENT VARIABLES
ENV   GENERATE_NEW_KEYS=false \
      CHANGE_JENKINS_PASSWD=false \
# $id$salt$password
# mkpasswd -m sha-512 -S <salt>
      JENKINS_PASSWD_HASH=$6$F6hy9uaD$5TajOLSfLRzXvnAYYAtu52KwofWcANOu0Mx2C2fQNG76eJO3J/DI1sS/89kErzGjH8T9QrBlcLkEDbDvHHvmi0 \
      JENKINS_AUTHORIZED_KEY=none

# ADD/COPY
COPY  entrypoint.sh /usr/local/bin/entrypoint.sh

# INSTALL
RUN   set -xe; \
      yum install -y openssh-server java-1.8.0-openjdk && \
      yum clean all && \
# ADD DEFAULT JENKINS USER (can be changed with env at runtime)
      useradd -m -d /home/jenkins -s /bin/sh jenkins && \
      echo "jenkins:jenkins" | chpasswd && \
# CONFIG SSHD / GENERATE KEYS IF NEEDED
      /usr/bin/ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N '' && \
      /usr/bin/ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N '' && \
      /usr/bin/ssh-keygen -q -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N '' && \
      mkdir /home/jenkins/.ssh && chown jenkins:jenkins /home/jenkins/.ssh && chmod 700 /home/jenkins/.ssh && \
      /usr/bin/ssh-keygen -t rsa -f /home/jenkins/.ssh/id_rsa -N '' && \
      /usr/bin/ssh-keygen -y -t rsa -f /home/jenkins/.ssh/id_rsa > /home/jenkins/.ssh/id_rsa.pub && \
      chmod +x /usr/local/bin/entrypoint.sh

# ENTRYPOINT
EXPOSE      22
ENTRYPOINT  ["/usr/local/bin/entrypoint.sh"]
