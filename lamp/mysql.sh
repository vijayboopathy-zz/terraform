#!/bin/bash
sudo apt update -y
export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password rootpw"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password rootpw"
sudo apt install mysql-server mysql-client -y
sudo systemctl enable mysql
sudo systemctl start mysql
