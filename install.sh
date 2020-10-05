#!/bin/bash
apt update&&apt upgrade
apt install nano git curl cron unzip bzip2 tar spell
PS3='Please choose an Option: '
options=("Debian" "Ubuntu" "Install Wordpress" "Install Lets Encrypt" "Install Teamspeak 3 Server" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Debian")
            wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
			echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
			#Update Server
apt update
apt upgrade

#Packages for the Installation
apt install ca-certificates apt-transport-https lsb-release gnupg curl nano unzip -y
apt install nano git curl cron unzip bzip2 tar spell
#Install Apache
apt install apache2 -y
#Install PHP and some important Packages
apt install php7.4 php7.4-cli php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-xml php7.4-xsl php7.4-zip php7.4-bz2 libapache2-mod-php7.4 -y
#Install MariaDB
apt install mariadb-server mariadb-client -y
#Setup MariaDB
#Install phpMyAdmin
cd /usr/share
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -O phpmyadmin.zip
unzip phpmyadmin.zip
rm phpmyadmin.zip
mv phpMyAdmin-*-all-languages phpmyadmin
chmod -R 0755 phpmyadmin

#Apache2 Config

echo "# phpMyAdmin Apache configuration

Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php
</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>" > /etc/apache2/conf-available/phpmyadmin.conf

#Activate the Config
a2enconf phpmyadmin
systemctl reload apache2

#Create phpMyAdmins Temp Storage
mkdir /usr/share/phpmyadmin/tmp/

#Creater User for phpMyAdmin


#ask user about username
read -p "Please enter the phpMyAdmin username you wish to create : " username

#ask user about password
read -p "Please Enter the Password for New User ($username) : " password

#Create User
mysql -e "CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';"

#mysql query that will create new user, grant privileges on database with entered password
query="GRANT ALL PRIVILEGES ON *.* TO '$username'@'localhost' WITH GRANT OPTION;"

#ask user to confirm all entered data
read -p "Executing Query : $query , Please Confirm (y/n) : " confirm

#if user confims then
if [ "$confirm" == 'y' ]; then

#run query
mysql -e "$query"

#update privileges, without this new user will be created but not active
mysql -e "flush privileges"

else

exit

fi
echo "Everything worked fine! Have a good day mate and stay safe"
exit
			;;
        "Ubuntu")
            apt install software-properties-common -y
			add-apt-repository ppa:ondrej/php
			#Update Server
apt update
apt upgrade

#Packages for the Installation
apt install ca-certificates apt-transport-https lsb-release gnupg curl nano unzip -y
apt install nano git curl cron unzip bzip tar
#Install Apache
apt install apache2 -y
#Install PHP and some important Packages
apt install php7.4 php7.4-cli php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-xml php7.4-xsl php7.4-zip php7.4-bz2 libapache2-mod-php7.4 -y
#Install MariaDB
apt install mariadb-server mariadb-client -y
#Setup MariaDB
#Install phpMyAdmin
cd /usr/share
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -O phpmyadmin.zip
unzip phpmyadmin.zip
rm phpmyadmin.zip
mv phpMyAdmin-*-all-languages phpmyadmin
chmod -R 0755 phpmyadmin

#Apache2 Config

echo "# phpMyAdmin Apache configuration

Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php
</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>" > /etc/apache2/conf-available/phpmyadmin.conf

#Activate the Config
a2enconf phpmyadmin
systemctl reload apache2

#Create phpMyAdmins Temp Storage
mkdir /usr/share/phpmyadmin/tmp/

#Creater User for phpMyAdmin


#ask user about username
read -p "Please enter the phpMyAdmin username you wish to create : " username

#ask user about password
read -p "Please Enter the Password for New User ($username) : " password

#Create User
mysql -e "CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';"

#mysql query that will create new user, grant privileges on database with entered password
query="GRANT ALL PRIVILEGES ON *.* TO '$username'@'localhost' WITH GRANT OPTION;"

#ask user to confirm all entered data
read -p "Executing Query : $query , Please Confirm (y/n) : " confirm

#if user confims then
if [ "$confirm" == 'y' ]; then

#run query
mysql -e "$query"

#update privileges, without this new user will be created but not active
mysql -e "flush privileges"

else

exit

fi
echo "Everything worked fine! Have a good day mate and stay safe <3"
exit
			;;
       "Install Wordpress")
	  cd /var/www/html
	  wget https://de.wordpress.org/latest-de_DE.zip
	  unzip latest-de_DE.zip
	  cd wordpress
	  mv * /var/www/html
	  find . -exec chown www-data:www-data {} \;
	  exit
			;;
			 "Install Lets Encrypt")
			 apt install certbot python-certbot-apache -y
			 certbot --authenticator webroot --installer apache
	        exit
			;;
			 "Install Teamspeak 3 Server")
			 adduser --disabled-login ts3
			 cd /home/ts3
			 wget https://files.teamspeak-services.com/releases/server/3.12.1/teamspeak3-server_linux_amd64-3.12.1.tar.bz2
			 tar xfvj teamspeak3-server_linux_amd64-3.12.1.tar.bz2
			 rm teamspeak3-server_linux_amd64-3.12.1.tar.bz2
			 cd teamspeak3-server_linux_amd64
			 touch .ts3server_license_accepted
			 ./ts3server_startscript.sh start
	        exit
			;;
			 "Quit")
	        exit
    esac
done
