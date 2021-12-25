#!/bin/bash

main () {

  # Ip
  ip -4 -br -c address
  read -p "IP? " ip;

  # Apt
  sudo apt update;  
  sudo apt upgrade;
  sudo apt install -y openjdk-17-* gcc g++ hexedit docker.io apache2 apache2-* unzip;
  sudo apt install mariadb-server mariadb-client
  sudo apt install php7.4 libapache2-mod-php7.4 php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline
  sudo apt install imagemagick php-imagick libapache2-mod-php7.4 php7.4-common php7.4-mysql php7.4-fpm php7.4-gd php7.4-json php7.4-curl php7.4-zip php7.4-xml php7.4-mbstring php7.4-bz2 php7.4-intl php7.4-bcmath php7.4-gmp
  sudo systemctl enable apache2
  sudo apt install phpmyadmin
  
  # Docker
  sudo systemctl enable --now docker; 
  docker --version | echo; 
  docker run hello-world;
  
  # Nextcloud
  sudo ufw allow http;
  sudo ufw allow https;
  sudo ufw allow 443/tcp;
  sudo chown -R akb1152 /var/www;
  wget https://download.nextcloud.com/server/releases/nextcloud-21.0.1.zip -O ~/Download/nextcloud.zip;
  sudo unzip nextcloud-21.0.1.zip -d /var/www/;
  setfacl -R -m u:www-data:rwx /var/www/;
  sudo a2enmod php7.4
 
  # Nextcloud-config
  echo "" | tee /etc/apache2/conf-available/nextcloud.conf
  java serverconf.java 911 /etc/apache2/conf-available/nextcloud.conf
  sudo a2enconf 
  sudo systemctl reload apache2;
  # <VirtualHost *:80>
  #      DocumentRoot "/var/www/nextcloud"
 #       ServerName $ip
#
  #      ErrorLog ${APACHE_LOG_DIR}/nextcloud.error
 #       CustomLog ${APACHE_LOG_DIR}/nextcloud.access combined
#
    #    <Directory /var/www/nextcloud/>
   #         Require all granted
  #          Options FollowSymlinks MultiViews
 #           AllowOverride All
#
   #        <IfModule mod_dav.c>
  #             Dav off
 #          </IfModule>
#
   #     SetEnv HOME /var/www/nextcloud
  #      SetEnv HTTP_HOME /var/www/nextcloud
 #       Satisfy Any
#
 #      </Directory>
#
#</VirtualHost>

  # Nextcloud HTTPS CONFIG
  java httpscfg.java /etc/apache2/sites-enabled/nextcloud-le-ssl.conf
  #Header always set Strict-Transport-Security "max-age=31536000"
  sudo apache2ctl -t
  sudo systemctl reload apache2
  mkdir /var/www/nextcloud-data
  
  # Nextcloud II 
  sudo a2ensite nextcloud.conf
  sudo a2enmod rewrite headers env dir mime setenvif ssl
  sudo apache2ctl -t
  sudo systemctl restart apache2
  
  
  # MySQL / MariaDB
  sudo systemctl enable mariadb;
  echo "when prompted for a passwd: press enter, when prompted if you want to set root passwd press y"
  echo "And after it just press Enter"
  read -p "ok? " understood;
  sudo mysql_secure_installation
  sudo mariadb -u root; 
  read -p "ok? " understood; 
  mariadb --version;
  echo "create database nextcloud;"
  echo "create user nextcloud@localhost identified by 'nextcloud-admin';"
  echo "grant all privileges on nextcloud.* to nextcloud@localhost identified by 'nextcloud-admin';";
  echo "flush privileges; exit;"
  sudo mysql;
  
  
  # phpmyadmin
  echo "show grants for phpmyadmin@localhost";
  sudo mysql -u root
  file /etc/apache2/conf-enabled/phpmyadmin.conf
  read -p "found symlink? " ok;
  sudo a2enconf phpmyadmin
  sudo systemctl reload apache2
  sudo ufw allow 443, 80;
  sudo cp /etc/apache2/conf-enabled/phpmyadmin.conf /etc/apache2/sites-available/phpmyadmin.conf
  #<VirtualHost *:80>
#    ServerName $ip
#    DocumentRoot /var/www/phpmyadmin
#
 #   ErrorLog ${APACHE_LOG_DIR}/phpadmin.error.log
  #  CustomLog ${APACHE_LOG_DIR}/phpadmin.access.log combined
  # ++ DOC phpmyadmin.conf ++
  # </VirtualHost>
  sudo a2ensite phpmyadmin.conf
  sudo systemctl reload apache2
  read -p "try firefox" in;
  sudo apt install certbot python3-certbot-apache
  sudo certbot --apache --agree-tos --redirect --hsts --staple-ocsp --must-staple -d $ip --email mcpe9005@gmail.com

}

main $@;
