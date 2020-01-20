#!/bin/bash -xe

# Add Universe as a package source
add-apt-repository -y universe

# Add Microsoft as a package source
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" > /etc/apt/sources.list.d/azure-cli.list

# Resync the package index files and upgrade all installed packages
apt clean & apt-get -y update
apt-get -y upgrade

# Flush IP tables
iptables -F

# Configure IP tables to allow inbound SSH, DHCP, and traffic for established outbound connections
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -j DROP

# Persist IP tables configuration
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
apt-get -y install iptables-persistent

# Install fail2ban
apt-get -y install fail2ban

# Configure fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i "s/maxretry = 5/maxretry = 3/" /etc/fail2ban/jail.local
sed -i "s/^\[sshd\]/[sshd]\nenabled=true/" /etc/fail2ban/jail.local

# Enable fail2ban to start as a service and start it now
systemctl enable fail2ban
systemctl start fail2ban

# Add Microsoft as a trusted package signer
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg

# Install jq, and packages needed to modify apt-package sources, and the azure cli
apt-get -y install jq  apt-transport-https lsb-release gnupg curl azure-cli

apt-get -y install apache2 apache2-doc apache2-npm-prefork apache2-utils libexpat1 ssl-cert
apt-get -y install php libapache2-mod-php php-mysql
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
systemctl restart apache2