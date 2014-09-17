#!/bin/bash/
echo 'address=/.dev/127.0.0.1' > /usr/local/etc/dnsmasq.conf;
cd ~/Downloads; 
wget https://github.com/drush-ops/drush/archive/master.zip;
unzip master.zip;
cp -R drush-master ~/drush;
curl -sS https://getcomposer.org/installer | php;
sudo mv composer.phar /usr/bin/composer;
cd ~/drush;
composer install;
echo "Please enter your computer username (/Users/USERNAME/)";
read UserName; echo "export PATH=$PATH:/Users/$UserName/drush" >> ~/.profile;
cd /usr/bin; ln -s /Users/$UserName/drush/drush;
cd /Applications/MAMP/conf/apache;
cp ~/.battleschool/httpd.conf .;
#cp ~/.battleschool/extra-httpd-vhosts.conf ./extra/httpd-vhosts.conf;
mkdir ~/.drush/;
cd ~/.drush/;
git clone git@aegir2.ryanwyse.com:/home/git/drush-aliases.git;
cp drush-aliases/* .;
mv drush-aliases/.git/ .;
rm -Rf drush-aliases/;
echo "Please enter your server username (ssh USERNAME@server.com)";
read ServerName; echo '<?php \n $user = '"'""$ServerName""'"'; \n $sites_dir = "/Users/'$UserName'/Sites";' > ~/.drush/myinfo.php;
php auto-git.php;
echo '<VirtualHost *:80>
  VirtualDocumentRoot /Users/'"$UserName"'/Sites/%1
  ServerAdmin webmaster@local.local
  ServerName locals.dev
  ServerAlias *.dev
  ErrorLog "logs/dynamic-error.local"
  CustomLog "logs/dynamic.local" common
</VirtualHost>
<VirtualHost *:80>
    VirtualDocumentRoot /Users/'"$UserName"'/Sites/%1
    ServerAdmin webmaster@local.local
    ServerName xip.io
    ServerAlias *.xip.io
    ErrorLog "logs/xip-dynamic-error.local"
    CustomLog "logs/xip-dynamic.local" common
</VirtualHost>' >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf;