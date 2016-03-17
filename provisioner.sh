#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

wget -nv https://download.owncloud.org/download/repositories/stable/xUbuntu_14.04/Release.key -O Release.key
apt-key add - < Release.key

echo 'deb http://download.owncloud.org/download/repositories/stable/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list
apt-get -y update

debconf-set-selections <<< 'mysql-server mysql-server/root_password password mysqlsecretpassword'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mysqlsecretpassword'

apt-get -y install mysql-server
mysql -uroot -pmysqlsecretpassword -e 'CREATE DATABASE IF NOT EXISTS owncloud;'
mysql -uroot -pmysqlsecretpassword -e 'GRANT ALL ON owncloud.* to "owncloud"@"localhost" IDENTIFIED BY "owncloudsecret";'


apt-get -y install owncloud php5-cli php5-curl php5-intl

sudo -u www-data php /var/www/owncloud/occ maintenance:install --admin-user=fodor --admin-pass=fodor --database=mysql --database-name=owncloud --database-user=owncloud --database-pass=owncloudsecret

sed -i -e "s/0 => 'localhost',/0 => 'localhost',\n    1 => '$DOMAIN'/g" -e "s/http:\/\/localhost/http:\/\/$DOMAIN/g" /var/www/owncloud/config/config.php
