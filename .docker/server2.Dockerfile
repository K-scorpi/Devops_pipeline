FROM ubuntu:22.04
RUN useradd -ms /bin/bash devops
RUN echo "devops:mypassword" | chpasswd
RUN usermod -aG root devops
RUN echo "devops ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN apt-get update && apt-get install -y openssh-server
COPY ./id_rsa.pub /root/.ssh/authorized_keys
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
RUN service ssh restart
EXPOSE 2222:22 
EXPOSE 80:80
EXPOSE 8080:8080
EXPOSE 443:443 
RUN apt-get install -y nginx-full
RUN apt-get install -y nano wget curl
RUN service nginx start  
COPY ./default /etc/nginx/sites-enabled/default
COPY ./default /etc/nginx/conf.d/redirect.conf
# VOLUME /var/log/nginx
RUN service nginx restart
# RUN mkdir -p /var/webserver/www
# USER devops