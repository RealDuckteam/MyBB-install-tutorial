# MyBB-install-tutorial

1. Installiere die erforderlichen Pakete

```
sudo apt-get update
sudo apt-get install apache2 php mysql-server php-mysql
```

2. Erstelle eine MySQL-Datenbank und einen MySQL-Benutzer

```
sudo mysql -u root -p
```

```
CREATE DATABASE mybb;
CREATE USER 'mybbuser'@'localhost' IDENTIFIED BY 'mypassword';
GRANT ALL PRIVILEGES ON mybb.* TO 'mybbuser'@'localhost';
FLUSH PRIVILEGES;
exit;
```

3. Lade die neueste Version von MyBB von der offiziellen MyBB-Website herunter

```
wget https://resources.mybb.com/downloads/mybb_1822.zip
```

4. Entpacke die ZIP-Datei und verschiebe den Inhalt in das Verzeichnis /var/www/html/

```
unzip mybb_1822.zip
sudo mv Upload/* /var/www/html/
```

5. Setze die Berechtigungen für das MyBB-Verzeichnis

```
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
```

6. Rufe die Installation von MyBB im Webbrowser auf, indem du die IP-Adresse oder den Domainnamen deines Servers gefolgt von /install aufrufst (z.B. http://localhost/install). Folge den Anweisungen auf dem Bildschirm, um MyBB zu installieren.




Das war's! Nach Abschluss der Installation kannst du dich bei deinem neuen MyBB-Forum anmelden und es an deine Bedürfnisse anpassen.
