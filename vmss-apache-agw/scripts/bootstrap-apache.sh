#!/bin/bash -e

set -x

# Turn off bash history
set +o history

# Restrict access to the cloud init log file
chmod 640 /var/log/cloud-init-output.log

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
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
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

# Install apache and php
apt-get -y install apache2 apache2-doc apache2-utils libexpat1 ssl-cert
apt-get -y install php libapache2-mod-php php-mysql

# Add info.php so we can get our IP
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Configure apache for index.php
sed -i "s/DirectoryIndex/DirectoryIndex index.php/" /etc/apache2/mods-enabled/dir.conf

# Download wordpress and install it in /var/www/html
cd /tmp
wget -O /tmp/latest.tar.gz http://wordpress.org/latest.tar.gz
tar -xzf /tmp/latest.tar.gz
rm -rf /var/www/html/wp-*
mv /tmp/wordpress/* /var/www/html
chown -R www-data:root /var/www/html
chmod 775 /var/www/html
cd /var/www/html

# Configure wordpress
mv wp-config-sample.php wp-config.php 
sed -i "s/define( *'DB_USER', '.*' *);/define( 'DB_USER', '${DB_USER}' );/" wp-config.php 
sed -i "s/define( *'DB_PASSWORD', '.*' *);/define( 'DB_PASSWORD', '${DB_PASSWORD}' );/" wp-config.php 
sed -i "s/define( *'DB_NAME', '.*' *);/define( 'DB_NAME', '${DB_DATABASE}' );/" wp-config.php 
sed -i "s/define( *'DB_HOST', '.*' *);/define( 'DB_HOST', '${DB_SERVER}' );/" wp-config.php 

# Generate Auth keys and salts
SALT=$(curl -s -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s wp-config.php

# Lock down wp-config.php
chmod 660 wp-config.php

# Restart apache
systemctl restart apache2

# Install jq
apt-get -y install jq

# Install packages needed to modify apt-package sources
apt-get -y install apt-transport-https lsb-release gnupg curl

# Install the CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Turn bash history back on
set -o history
