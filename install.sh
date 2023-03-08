#!/bin/bash

# Install required packages
sudo apt update
sudo apt install apache2 mysql-server php php-mysql libapache2-mod-php php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip -y

# Download and extract MyBB
wget https://mybb.com/download/latest
unzip latest
mv Upload mybb
cd mybb

# Create database and user for MyBB
MYSQL_ROOT_PASSWORD='your_mysql_root_password'
MYSQL_MYBB_PASSWORD='mybb_user_password'
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE mybb;"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER 'mybbuser'@'localhost' IDENTIFIED BY '$MYSQL_MYBB_PASSWORD';"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON mybb.* TO 'mybbuser'@'localhost';"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

# Configure MyBB
sudo mv inc/config.default.php inc/config.php
sudo chown www-data:www-data inc/config.php
sudo sed -i "s/'database'/'mysqli'/" inc/config.php
sudo sed -i "s/'db_name' => ''/'db_name' => 'mybb'/" inc/config.php
sudo sed -i "s/'db_user' => ''/'db_user' => 'mybbuser'/" inc/config.php
sudo sed -i "s/'db_pass' => ''/'db_pass' => '$MYSQL_MYBB_PASSWORD'/" inc/config.php
sudo sed -i "s/'db_host' => 'localhost'/'db_host' => 'localhost'/" inc/config.php
sudo sed -i "s/'table_prefix' => 'mybb_'/'table_prefix' => 'mybb_'/" inc/config.php

# Copy MyBB to web directory
sudo cp -r ~/mybb/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/

# Restart Apache
sudo systemctl restart apache2
