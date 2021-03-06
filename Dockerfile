FROM vimal13/apache-webserver-php
EXPOSE 80

RUN yum update -y
RUN yum install openssh-server -y
RUN yum install java-1.8.0-openjdk -y
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN echo "export VISIBLE=now" >> /etc/profile
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

ENV NOTVISIBLE="in users profile"
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
CMD /usr/sbin/httpd -DFOREGROUND && /bin/bash

