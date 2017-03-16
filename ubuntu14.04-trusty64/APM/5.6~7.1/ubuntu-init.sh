#!/usr/bin/env bash

APT_ARCHIVE_OLD_REPO_URL="archive.ubuntu.com" # 기존 apt archive 저장소
APT_SECURITY_OLD_REPO_URL="security.ubuntu.com" # 기존 apt security 저장소
APT_ARCHIVE_NEW_REPO_URL="ftp.daum.net" # 변경 apt archive 저장소
APT_SECURITY_NEW_REPO_URL="ftp.daum.net" # 변경 apt security 저장소
MYSQL_ROOT_PASSWORD="root" # Mysql root계정 암호
MYSQL_ALLOW_IP="" # 외부 접속 허용할 경우의 IP
PHP_VERSION="7.1" # PHP 버전 5.6, 7.0, 7.1 가능

vi -c "%s/${APT_ARCHIVE_OLD_REPO_URL}/${APT_ARCHIVE_NEW_REPO_URL}/g" -c "wq" /etc/apt/sources.list
vi -c "%s/${APT_SECURITY_OLD_REPO_URL}/${APT_SECURITY_NEW_REPO_URL}/g" -c "wq" /etc/apt/sources.list

Update () {
    echo "-- Update packages --"
    sudo apt-get update
    sudo apt-get upgrade
}
Update

echo "-- Prepare configuration for MySQL --"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}"

echo "-- Install tools and helpers --"
sudo apt-get autoremove -y --force-yes
sudo apt-get install -y --force-yes python-software-properties vim htop curl git npm

echo "-- Install PPA's --"
sudo add-apt-repository ppa:ondrej/php
Update

echo "-- Install packages --"
sudo apt-get install -y --force-yes apache2 mysql-server-5.6
sudo apt-get install -y --force-yes php${PHP_VERSION} php${PHP_VERSION}-common php${PHP_VERSION}-dev php${PHP_VERSION}-json php${PHP_VERSION}-opcache php${PHP_VERSION}-cli libapache2-mod-php${PHP_VERSION} php${PHP_VERSION}-mysql php${PHP_VERSION}-curl php${PHP_VERSION}-gd php${PHP_VERSION}-mcrypt php${PHP_VERSION}-mbstring php${PHP_VERSION}-bcmath php${PHP_VERSION}-soap
Update

sudo a2enmod rewrite

echo "-- Install Composer --"
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

echo "-- Setup databases --"

if [${MYSQL_ALLOW_IP}!=""]; then
    mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'${MYSQL_ALLOW_IP}' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION; FLUSH PRIVILEGES;"
    vi -c "%s/127.0.0.1/0.0.0.0/g" -c "wq" /etc/mysql/my.cnf
fi

exit 0