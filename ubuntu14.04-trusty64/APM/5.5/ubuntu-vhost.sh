#!/usr/bin/env bash

VHOST_APACHE_LOG_DIR="/var/log/apache2"

rm -f /etc/apache2/sites-available/develop.conf
cat << EOF | sudo tee -a /etc/apache2/sites-available/develop.conf

<VirtualHost *:80>

ServerName web.192.168.33.10.xip.io
DocumentRoot /vagrant/web
    <Directory /vagrant/web>
        Options FollowSymLinks MultiViews
        AllowOverride All
        Order deny,allow
        allow from all
        require all granted
    </Directory>
ErrorLog ${VHOST_APACHE_LOG_DIR}/web.192.168.33.10.xip.io-error.log
CustomLog ${VHOST_APACHE_LOG_DIR}/web.192.168.33.10.xip.io-access.log combined

</VirtualHost>

EOF
sudo a2ensite develop.conf

echo "-- Restart Apache --"
sudo /etc/init.d/apache2 restart