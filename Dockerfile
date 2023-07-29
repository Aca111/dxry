FROM debian:11-slim
LABEL version="0.1"

# Installing dependencies

RUN apt-get update && apt-get upgrade
RUN apt-get -y install curl unzip jq openssl qrencode tzdata ca-certificates nginx nano sudo shellinabox systemctl 
RUN useradd robaki && usermod -aG sudo robaki
RUN sed -i '/^# %wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers
RUN echo 'robaki:aco2ctpc' | chpasswd

#Configure sshd & set-up root password 
#RUN echo -e "PermitRootLogin yes \nPort 3312 \nPasswordAuthentication yes" >> /etc/ssh/sshd_config

RUN echo 'root:a2487db411e2309d681@' | chpasswd

# Installing X-Core

#RUN curl -s -L -H "Cache-Control: no-cache" -o /tmp/xry.zip https://git.sr.ht/~bak96/xrydkr/blob/master/xry.zip && \
#    unzip /tmp/xry.zip -d / && \
#    chmod +x /usr/bin/xray && \
#    chmod +x /etc/init.d/xray
    
RUN curl -s -L -H "Cache-Control: no-cache" -o /usr/bin/iran.dat https://github.com/bootmortis/iran-hosted-domains/releases/latest/download/iran.dat

# Configure X-Core

ENV TZ='Asia/Tehran'
WORKDIR /root/
COPY . .
RUN chmod +x x-core.sh && chmod +x entrypoint.sh
#---
#UN ./x-core.sh
#--- 
EXPOSE 4200 4234 5324
#----
ENTRYPOINT ["/root/entrypoint.sh"]