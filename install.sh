#!/bin/bash

# MyBB Version
MYBB_VERSION="1822"

# MySQL Datenbankinformationen
DB_NAME="mybb"
DB_USER="mybbuser"
DB_PASSWORD="mypassword"

# Pfad zur MyBB-Installationsdatei
MYBB_INSTALL_FILE="https://resources.mybb.com/downloads/mybb_${MYBB_VERSION}.zip"

# Verzeichnis, in dem MyBB installiert werden soll
INSTALL_DIR="/var/www/html/"

# Apache2 Konfigurationsdatei für MyBB
APACHE_CONF="mybb.conf"

# Prüfen, ob das Skript als Root ausgeführt wird
if [ "$(id -u)" != "0" ]; then
    echo "Das Skript muss als Root ausgeführt werden. Bitte mit sudo ausführen."
    exit 1
fi

# Pakete installieren
echo "Pakete werden installiert..."
apt-get update
apt-get install -y apache2 php mysql-server php-mysql unzip

# MySQL-Datenbank und Benutzer erstellen
echo "MySQL-Datenbank und Benutzer werden erstellt..."
mysql -u root -p <<MYSQL
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
MYSQL

# MyBB herunterladen und installieren
echo "MyBB wird heruntergeladen und installiert..."
wget "${MYBB_INSTALL_FILE}"
unzip "mybb_${MYBB_VERSION}.zip"
mv "Upload/*" "${INSTALL_DIR}"
chown -R www-data:www-data "${INSTALL_DIR}"
chmod -R 755 "${INSTALL_DIR}"
rm -rf "mybb_${MYBB_VERSION}.zip" "Upload/"

# Apache2 Konfigurationsdatei für MyBB erstellen und aktivieren
echo "Apache2-Konfigurationsdatei wird erstellt..."
echo "<Directory ${INSTALL_DIR}>" > "/etc/apache2/sites-available/${APACHE_CONF}"
echo "    Options FollowSymLinks" >> "/etc/apache2/sites-available/${APACHE_CONF}"
echo "    AllowOverride All" >> "/etc/apache2/sites-available/${APACHE_CONF}"
echo "</Directory>" >> "/etc/apache2/sites-available/${APACHE_CONF}"
echo "<VirtualHost *:80>" >> "/etc/apache2/sites-available/${APACHE_CONF}"
echo "    ServerAdmin webmaster@localhost" >> "/etc/apache2/sites-available/${APACHE_CONF}"
echo "    DocumentRoot ${INSTALL_DIR}" >> "/etc/apache2/sites-available/${APACHE_CONF}"
echo "    ServerName localhost" >> "/etc/apache2/sites-available/${APACHE_CONF}"
echo "</VirtualHost>" >> "/etc/apache2/sites-available/${APACHE_CONF}"
a2ensite "${APACHE_CONF}"

# Apache2 neustarten
echo "Apache2 wird neugestartet..."
systemctl restart apache2

echo "Installation abgeschlossen!"
