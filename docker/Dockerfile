FROM masatoshi/centos:6.7

RUN yum install -y passwd sudo openssh-server
RUN yum reinstall -y glibc-common

RUN groupadd docker
RUN useradd docker -g docker -G wheel
RUN echo "docker"|passwd --stdin docker""
RUN echo "docker        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/docker
RUN chmod 0440 /etc/sudoers.d/docker
RUN mkdir -pm 700 /home/docker/.ssh
COPY authorized_keys /home/docker/.ssh/authorized_keys
RUN chmod 0600 /home/docker/.ssh/authorized_keys
RUN chown -R docker:docker /home/docker/.ssh
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN /etc/init.d/sshd start
RUN /etc/init.d/sshd stop

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
