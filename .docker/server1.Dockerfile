FROM ubuntu:22.04
RUN useradd -ms /bin/bash devops
RUN echo "devops:mypassword" | chpasswd
RUN usermod -aG root devops
RUN echo "devops ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN apt-get update && apt-get install -y openssh-server
COPY ./id_rsa.pub /root/.ssh/authorized_keys
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
RUN service ssh restart
EXPOSE 2221:22

RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y postgresql postgresql-contrib
RUN chown -R postgres:postgres /var/lib/postgresql
RUN apt-get install -y postgresql-client
RUN apt-get install -y bash-completion
RUN export PATH=$PATH:/usr/share/postgresql/14/bin
RUN service postgresql start
USER postgres
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER app WITH SUPERUSER PASSWORD 'app';" &&\
    createdb -O app app
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER custom WITH SUPERUSER PASSWORD 'custom';" &&\
    createdb -O custom custom       
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER service WITH SUPERUSER PASSWORD 'service';" &&\
    psql --command "GRANT CONNECT ON DATABASE app to service;" &&\
    psql --command "GRANT CONNECT ON DATABASE custom to service;"
EXPOSE 5432:5432
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# USER devops