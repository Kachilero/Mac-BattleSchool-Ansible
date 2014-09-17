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
cd /Applications/MAMP/conf/apache;
cp ~/.battleschool/httpd.conf .;
cp ~/.battleschool/extra-httpd-vhosts.conf ./extra/httpd-vhosts.conf;
cd ~/.drush/;
git clone git@aegir2.ryanwyse.com:/home/git/drush-aliases.git;
cp drush-aliases/* .;
mv drush-aliases/.git/ .;
rm -Rf drush-aliases/;
php auto-git.php;