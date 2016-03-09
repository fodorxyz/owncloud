#!/bin/bash

wget -nv https://download.owncloud.org/download/repositories/stable/xUbuntu_14.04/Release.key -O Release.key
apt-key add - < Release.key

echo 'deb http://download.owncloud.org/download/repositories/stable/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list
apt-get update
apt-get install owncloud
