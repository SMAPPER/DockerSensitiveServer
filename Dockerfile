FROM dperson/samba
MAINTAINER justin@hasecuritysolutions.com

# Create the log file to be able to run tail
RUN apt-get update \
    && apt -y install curl wget apt-transport-https netcat ssh samba \
    && wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt update \
    && apt install -y powershell \
    && mkdir /opt/confidential \
    && chmod 777 -R /opt/confidential \
    && echo "[pci]" >> /etc/samba/smb.conf \
    && echo "    comment = Emulated Windows Share" >> /etc/samba/smb.conf \
    && echo "    path = /opt/confidential" >> /etc/samba/smb.conf \
    && echo "    read only = no" >> /etc/samba/smb.conf \
    && echo "    browsable = yes" >> /etc/samba/smb.conf \
    && echo "    guest ok = yes" >> /etc/samba/smb.conf
COPY ./sensitive_data.csv /opt/
RUN /usr/sbin/smbd -D -s /etc/samba/smb.conf