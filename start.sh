#!/bin/bash/

#install pip
echo 'installing battleschool';
sudo easy_install pip;
sudo pip install battleschool;
mkdir ~/.battleschool;

# move everything to .battleschool directory
echo 'moving everything to the battleschool directory';
cp -R ~/Downloads/Mac-BattleSchool-Ansible-master/* ~/.battleschool/;
cd ~/.battleschool;
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
brew doctor;

# run battleschool
echo 'running battleschool';
battle --config-file ~/.battleschool/config.yml --module-path=/usr/share/battleschool/library --ask-sudo-pass;

#config dnmasq
echo 'config dnsmasq';
cp $(brew list dnsmasq | grep /dnsmasq.conf.example$) /usr/local/etc/dnsmasq.conf;
sudo cp $(brew list dnsmasq | grep /homebrew.mxcl.dnsmasq.plist$) /Library/LaunchDaemons/;
sudo echo 'address=/.dev/127.0.0.1' > /usr/local/etc/dnsmasq.conf;
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist;
sudo mkdir /etc/resolver;
sudo touch /etc/resolver/dev;
sudo echo 'nameserver 127.0.0.1' > /etc/resolver/dev;

#download drush
echo 'download drush';
cd ~/Downloads;
wget https://github.com/drush-ops/drush/archive/master.zip;
unzip master.zip;
cp -R drush-master ~/drush;
curl -sS https://getcomposer.org/installer | php;
sudo mv composer.phar /usr/bin/composer;
cd ~/drush;
composer install;
echo "Please enter your computer username (/Users/USERNAME/)";
if [ ! -f /usr/bin/drush ]; then
    #if not there add to path and sym link it
    read UserName; echo "export PATH=$PATH:/Users/$UserName/drush" >> ~/.profile;
    cd /usr/bin; sudo ln -s /Users/$UserName/drush/drush /usr/bin/drush;
fi

#download/config mamp
echo 'download mamp';
if [ ! -f /Applications/MAMP/README.rtf ]; then
    #if we cannot find readme then mamp isn't installed
    wget -P ~/Downloads/ http://downloads10.mamp.info/MAMP-PRO/releases/3.0.7.2/MAMP_MAMP_PRO_3.0.7.2.pkg;
    open ~/MAMP_MAMP_PRO_3.0.7.2.pkg;
    echo 'Hit enter when done installing MAMP';
    read WaitingForEnter;
fi
echo 'configure mamp';
cd /usr/local/bin; sudo ln -s /Applications/MAMP/Library/bin/mysql mysql;
cd /Applications/MAMP/conf/apache;
cp ~/.battleschool/httpd.conf .;
cp ~/.battleschool/php.ini /Applications/MAMP/conf/php5.4.30/php.ini;
cp ~/.battleschool/php.ini /Applications/MAMP/bin/php/php5.4.30/conf/php.ini;
cp ~/.battleschool/my.cnf /Applications/MAMP/conf/my.cnf;
rm -R /Applications/MAMP/bin/php/php5.1.6;
rm -R /Applications/MAMP/bin/php/php5.2.17;
rm -R /Applications/MAMP/bin/php/php5.3.28;
#if never launched these don't exist
rm /Applications/MAMP/db/mysql/ib_logfile0;
rm /Applications/MAMP/db/mysql/ib_logfile1;
#build virtual hosts
if [ ! -f /Applications/MAMP/conf/apache/extra/ran-script.txt ]; then
    #we don't want to keep appending this onto the end, that probably does bad things
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
    touch /Applications/MAMP/conf/apache/extra/ran-script.txt;
fi

# set up autogit drush
# if you aren't in Code Koalas, then you don't have this and can skip this
# our auto-git code is pretty clever
# if a new drush alias is made and pushed up,
# the site auto downloads on every computer
# so people can 'instantly' start local development with no setup
# it's basically magic

echo 'setting up the drush auto-git';
mkdir ~/.drush/;
cd ~/.drush/;
git clone git@aegir2.ryanwyse.com:/home/git/drush-aliases.git;
cp drush-aliases/* .;
mv drush-aliases/.git/ .;
rm -Rf drush-aliases/;
echo "Please enter your server username (ssh USERNAME@server.com)";
read ServerName; echo '<?php \n $user = '"'""$ServerName""'"'; \n $sites_dir = "/Users/'$UserName'/Sites";' > ~/.drush/myinfo.php;

echo 'ALMOST DONE! Going to open MAMP for the first time!';
echo 'Choose just regular MAMP, not MAMP PRO';
open -a 'MAMP';
echo 'Once servers are running hit enter';
read WaintingOnEnter;

echo 'about to pull in all the drush auto-git sites (this may take awhile)';
php auto-git.php;
