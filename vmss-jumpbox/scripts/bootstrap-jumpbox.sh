#!/bin/bash -xe

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

# Install jq
apt-get -y install jq

# Install packages needed to modify apt-package sources
apt-get -y install apt-transport-https lsb-release gnupg curl

# Install the CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
