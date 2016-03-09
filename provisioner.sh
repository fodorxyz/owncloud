#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

wget -nv https://download.owncloud.org/download/repositories/stable/xUbuntu_14.04/Release.key -O Release.key
apt-key add - < Release.key

echo 'deb http://download.owncloud.org/download/repositories/stable/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list
apt-get -y update

debconf-set-selections <<< 'mysql-server mysql-server/root_password password mysqlsecretpassword'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mysqlsecretpassword'

apt-get -y install owncloud php5-cli php5-curl php5-intl
