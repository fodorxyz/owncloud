#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

wget -nv https://download.owncloud.org/download/repositories/stable/xUbuntu_14.04/Release.key -O Release.key
apt-key add - < Release.key

echo 'deb http://download.owncloud.org/download/repositories/stable/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list
apt-get -y update

debconf-set-selections <<< "mysql-server mysql-server/root_password password ${RANDOM_PASSWORD}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${RANDOM_PASSWORD}"

export OWNCLOUD_DB_PASSWORD=$(gen_password)

apt-get -y install mysql-server
mysql -u root -p '${RANDOM_PASSWORD}' -e 'CREATE DATABASE IF NOT EXISTS owncloud;'
mysql -u root -p '${RANDOM_PASSWORD}' -e "GRANT ALL ON owncloud.* to 'owncloud'@'localhost' IDENTIFIED BY '${OWNCLOUD_DB_PASSWORD}';"

apt-get -y install owncloud php5-cli php5-curl php5-intl php5-gd php5-json php5-mcrypt php5-imagick

sudo -u www-data php /var/www/owncloud/occ maintenance:install --admin-user=$ADMIN_USERNAME --admin-pass=$ADMIN_PASSWORD --database=mysql --database-name=owncloud --database-user=owncloud --database-pass=${OWNCLOUD_DB_PASSWORD}

sed -i -e "s/0 => 'localhost',/0 => 'localhost',\n    1 => '$DOMAIN'/g" -e "s/http:\/\/localhost/http:\/\/$DOMAIN/g" /var/www/owncloud/config/config.php
