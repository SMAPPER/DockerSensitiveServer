FROM ubuntu:18.04
MAINTAINER justin@hasecuritysolutions.com

# Create the log file to be able to run tail
RUN apt-get update
RUN apt -y install curl wget apt-transport-https netcat ssh samba
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt update
RUN apt install -y powershell
RUN mkdir /opt/confidential
RUN chmod 777 -R /opt/confidential
RUN echo "[pci]" >> /etc/samba/smb.conf
RUN echo "    comment = Emulated Windows Share" >> /etc/samba/smb.conf
RUN echo "    path = /opt/confidential" >> /etc/samba/smb.conf
RUN echo "    read only = no" >> /etc/samba/smb.conf
RUN echo "    browsable = yes" >> /etc/samba/smb.conf
RUN echo "    guest ok = yes" >> /etc/samba/smb.conf
COPY ./sensitive_data.csv /opt/
CMD /usr/sbin/smbd -D -s /etc/samba/smb.conf